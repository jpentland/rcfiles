#!/usr/bin/env python3
import subprocess
from Xlib import X, display
from Xlib.ext import randr

class monmon:
    def __init__(self):
        self.d = display.Display()
        self.s = self.d.screen()
        self.window = self.s.root.create_window(0,0,1,1,1, self.s.root_depth)

    def getmonitors(self):
        mons=[]
        res = randr.get_screen_resources(self.window)
        for output in res.outputs:
            info = randr.get_output_info(self.window, output, 0)
            if len(info.modes) > 0:
                mons.append(info.name)

        return mons

def wait_change():
    shell("udevadm monitor --subsystem=drm | grep -m 1 \"KERNEL.*(drm)\"")

def shell(command):
    print("sh: %s" % command)
    try:
        output = subprocess.check_output(command, shell=True).decode("UTF-8")
        print("output: %s" % output)
        return output
    except subprocess.CalledProcessError:
        print("Warning: Command failed")
        return ""

def add_monitor(mon):
    print("Adding monitor %s" % mon)
    shell("sleep 6s")

    # Find first unfocused desktop
    unfocused = shell("bspc query -D -d '.!focused'").split()[0]

    # Move it to new monitor
    shell("bspc desktop %s -m %s" % (unfocused, mon))

    # Activate it
    shell("bspc desktop %s -a" % unfocused)

    # Remove "Desktop" desktop
    shell("bspc desktop Desktop -r")

    # Re-run "feh" command
    shell("feh --bg-scale ~/.wmbg")

    # Restart bspstatus
    shell("bspstatus -r")

def del_monitor(mon, mons):
    print("Removing monitor %s" % mon)
    shell("sleep 6s")

    # Create "temp" desktop on removed monitor
    shell("bspc monitor %s -a temp" % mon)

    # Activate "temp" on removed monitor
    shell("bspc desktop temp -a")

    # Move all desktops on removed monitor to first non-removed monitor
    for desktop in shell("bspc query -D -m %s" % mon).split():
        if desktop != "temp":
            shell("bspc desktop %s -m %s" % (desktop, mons[0]))

    # Remove removed monitor
    shell("bspc monitor %s -r" % (mon))

    # Re-run "feh" command
    shell("feh --bg-scale ~/.wmbg")

    # Restart bspstatus
    shell("bspstatus -r")

def main():
    monitor = monmon()
    oldmons = monitor.getmonitors()
    while True:
        wait_change()
        newmons = monitor.getmonitors()
        for mon in newmons:
            if mon not in oldmons:
                add_monitor(mon)
        for mon in oldmons:
            if mon not in newmons:
                del_monitor(mon, newmons)
        oldmons = newmons

if __name__ == "__main__": main()
