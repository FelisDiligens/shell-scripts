#!/usr/bin/env python3

"""
Implements rudimentary hot corners (top left of screen) to open overview under Windows 10/11.
Also, scrolling in the corner will cycle virtual desktops.

Requirements:
- screeninfo
- pyautogui
- pynput

pip install screeninfo pyautogui pynput
"""

import screeninfo
import pyautogui
import sys
import time
import traceback
import pynput


def main(args):
    print("Hot corners for Windows.")

    # Fail safe is in the upper left corner, which we want to use ourselfes.
    pyautogui.FAILSAFE = False

    # Get the corners of the screen(s):
    corners = []
    for monitor in screeninfo.get_monitors():
        print("* %s monitor (%s) %s- Corner: %d, %d" % (
                "Primary" if monitor.is_primary else "Secondary",
                monitor.name,
                "  " if monitor.is_primary else "",
                monitor.x, monitor.y))
        corners.append(
            pyautogui.Point(
                x=monitor.x,
                y=monitor.y
            )
        )

    def on_scroll(x, y, dx, dy):
        # Cycle virtual desktops on scroll:
        if pyautogui.Point(x=x, y=y) in corners:
            if dy < 0: # down
                pyautogui.hotkey("ctrl", "win", "right")
            else: # up
                pyautogui.hotkey("ctrl", "win", "left")

    pynput.mouse.Listener(on_scroll=on_scroll).start()

    print("Listening... (Press Ctrl+C to quit)")
    mouse_was_in_corner = False
    try:
        while True:
            mouse_pos = pyautogui.position()
            if mouse_pos in corners:
                # Keep track if mouse was in corner before as to not trigger overview hotkey again.
                if not mouse_was_in_corner:
                    pyautogui.hotkey("win", "tab")
                    time.sleep(0.5) # Wait a bit after triggering overview hotkey.
                mouse_was_in_corner = True
            else:
                mouse_was_in_corner = False
            time.sleep(0.1)
    except KeyboardInterrupt:
        print("^C")
        return 0
    except:
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))

