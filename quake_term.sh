#!/bin/sh
# quake_term.sh: emulates quake terminal drop-down functionality
# Copyright 2011 Jimmy Wu (jw013)
#
# IMPORTANT: wmctrl and xprop are required to run this script
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

quake_term_wmclass=quake_xterm

# make sure wmctrl exists
if ! command -v wmctrl >/dev/null 2>&1; then
    echo Error: required dependency wmctrl not found. >&2
    exit 1
fi

active_window_id=\
"$(xprop -root | sed -n -e '/^_NET_ACTIVE/s/^[[:print:]]\{40\}//p')"

# if active window WM_CLASS matches $quake_term_wmclass
if xprop -id "$active_window_id" 2>/dev/null | \
    grep -q '^WM_CLASS(STRING)[[:print:]]*'"$quake_term_wmclass" 
then # hide active quake term
    wmctrl -i -r "$active_window_id" -b add,hidden 
# else, attempt to both focus and raise quake terminal
# If unsuccessful, no quake terminal is running, so start one
elif ! wmctrl -R "$quake_term_wmclass" -x ; then
    lxterm -geometry 88x24 -name "$quake_term_wmclass" &
fi

