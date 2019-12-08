import os
MAX_NOTIFY_TIMEOUT=1000
DEFAULT_NOTIFY_TIMEOUT=1000
STATUS_UPDATE_INTERVAL=2
STATUS_COMMAND = [ '/bin/sh', '%s/.config/statnot/statusline.sh' % os.getenv('HOME') ]
