#!/usr/bin/env python
import fileinput
from os import path
import sys

cfg_focused = "#00ff00"
cfg_empty = "#888888"
cfg_occupied = "#ffffff"
cfg_urgent = "#ff0000"
cfg_other = "#228822"

# desktop format: {name : {"fg": fg_color},}
def process_line(line):
    on_focused_monitor = False
    desktops = {}
    layout = ""

    if line[0] == "W":
        line = line[1:]
    for part in line.split(':'):
        cmd = part[0]
        parm = part[1:]
        if cmd == "m":
            on_focused_monitor = False
        elif cmd == "M":
            on_focused_monitor = True
        elif cmd == "F" or cmd == "O":
            if on_focused_monitor:
                desktops[parm] = {"fg" : cfg_focused }
            else:
                desktops[parm] = {"fg" : cfg_other }
        elif cmd == "o":
            desktops[parm] = { "fg" : cfg_occupied }
        elif cmd == "U" or cmd == "u":
            desktops[parm] = { "fg" : cfg_urgent }
        elif cmd == "f":
            desktops[parm] = { "fg" : cfg_empty }
        elif cmd == "L" and on_focused_monitor:
            if parm == "T":
                layout = "tiled"
            elif parm == "M":
                layout = "monocle"
    return (desktops, layout)

def format_desktops(desktops, layout):
    desktop_list = []
    for desktop in sorted(desktops):
        desktop_list.append(cfg(desktop, desktops[desktop]["fg"]))
    return ' '.join(desktop_list)

def cfg(text, color):
    return "^fg(%s)%s^fg()" % (color, text)

for line in fileinput.input():
    desktops, layout = process_line(line.strip())
    ws = format_desktops(desktops, layout)
    print("ws %s" % ws)
    print("layout %s" % layout)
    sys.stdout.flush()
