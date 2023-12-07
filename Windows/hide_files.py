#!/usr/bin/env python3

import os
import sys
import platform
import subprocess
import ctypes
import argparse
from pathlib import Path

# https://stackoverflow.com/a/25432403
# https://stackoverflow.com/a/43441940
FILE_ATTRIBUTE_HIDDEN = 0x02


def set_hidden_attrib(file_name):
    """
    Adds the NTFS hidden attribute to a file or folder.
    Calls the SetFileAttributesW WinApi function or attrib.exe, depending on what's available.
    """
    # Check if running under Windows natively:
    if platform.system() == "Windows":
        # https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-setfileattributesw
        ret = ctypes.windll.kernel32.SetFileAttributesW(
            str(file_name), FILE_ATTRIBUTE_HIDDEN
        )
        if not ret:  # There was an error.
            raise ctypes.WinError()
    # Check if running under Cygwin. Try ATTRIB.exe:
    elif platform.system().startswith("CYGWIN_NT"):
        # Get native file path:
        native_file_name = (
            subprocess.check_output(["cygpath", "-w", str(file_name)])
            .decode("UTF-8")
            .strip()
        )
        # Call ATTRIB.exe with native file path:
        # print(f"> ATTRIB.exe +H /D /L \"{native_file_name}\"")
        subprocess.check_call(["attrib", "+H", "/D", "/L", native_file_name])


def hide_files(folder, depth=1, verbose=False):
    """
    Hides all files and folders that start with a ".".
    Reads .hidden file, if it exists and hides all files and folders written in that file (newline separated).
    If depth > 1, will look into subdirectories recursively.
    """

    if depth < 1:
        return

    # Read .hidden:
    hidden = []
    try:
        if (folder / ".hidden").is_file():
            with open(folder / ".hidden", "r") as f:
                hidden = list(filter(None, f.read().split("\n")))
    except Exception as ex:
        print(f"Couldn't read file \"{folder / '.hidden'}\": {ex}")

    # Hide matching files and folders:
    try:
        for entry in os.listdir(folder):
            entry_path = folder / entry
            if entry.startswith(".") or entry.endswith("~") or entry in hidden:
                try:
                    if verbose:
                        print(entry_path)
                    set_hidden_attrib(entry_path)
                except Exception as ex:
                    print(f'Couldn\'t hide "{entry_path}": {ex}')
            if depth > 1 and entry_path.is_dir():
                hide_files(entry_path, depth - 1, verbose)
    except Exception as ex:
        print(f'Couldn\'t search directory "{folder}": {ex}')


def range_limited_int_type(arg):
    """Type function for argparse"""
    try:
        n = int(arg)
    except ValueError:    
        raise argparse.ArgumentTypeError("argument must be a number")
    if n < 1:
        raise argparse.ArgumentTypeError("argument must be at least 1")
    return n


if __name__ == "__main__":
    if platform.system() != "Windows" and not platform.system().startswith("CYGWIN_NT"):
        print("Run this script under Windows!")
        sys.exit(-1)

    parser = argparse.ArgumentParser(
        prog="hide-files.py",
        description='Adds the NTFS hidden attribute to all files and folders that start with a ".".\n'
        + "Reads .hidden file, if it exists and hides all files and folders written in that file (newline separated).",
        epilog="uses ~ if no paths were given",
    )
    parser.add_argument("folders", nargs="*", default=[Path.home()])
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="print which files/folders get hidden",
    )
    parser.add_argument(
        "-d",
        "--depth",
        type=range_limited_int_type,
        default=1,
        help="search subdirectories",
    )
    args = parser.parse_args()
    folders = [Path(p) for p in args.folders]

    for folder in folders:
        hide_files(folder, args.depth, args.verbose)