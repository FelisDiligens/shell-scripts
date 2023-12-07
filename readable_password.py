#!/usr/bin/env python3
from random import randint
import argparse

# Based on the work of Christian Haensel and Josh Hartman
# (https://gist.github.com/joshhartman/1507069#file-randompassword-php)
# Rewritten from PHP 7 to Python 3 and modified slightly

# Examples (arguments: `-csl 10`): Davocha!46, Xafeeda^17, Fiethek&04

consonants = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "v", "w", "x", "y", "z", "sh", "sn", "tr", "th", "ch"]
vowels = ["a", "e", "i", "o", "u", "ee", "oo", "ie", "au"]
special_characters = ["!", "@", "#", "$", "%", "^", "&", "*", "-", "+", "?", "=", "~"]


def random_password(length=10, capitalize=True, special_char=True):
    if length < 6:
        raise ValueError("Length parameter must be greater than or equal to 6")

    password = ""

    for _ in range(0, length // 2):
        password += consonants[randint(0, 24)]
        password += vowels[randint(0, 8)]
    password = password[:length - 2] # Trim to password length. Makes room for a two-digit number on the end.

    if special_char:
        password = password[:-1] + special_characters[randint(0, 12)]

    password += str(randint(0, 99)).zfill(2)

    if capitalize:
        password = password.capitalize()

    return password


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog="readable-password.py", description="Human Readable Password Generator"
    )
    parser.add_argument(
        "-l",
        "--length",
        type=int,
        default=10,
        help="Password length. Must be greater than or equal to 6.",
    )
    parser.add_argument(
        "-c",
        "--capitalize",
        action="store_true",
        help="Capitalize password (first character will be uppercase)",
    )
    parser.add_argument(
        "-s",
        "--special-char",
        action="store_true",
        help="Adds a random special character between the word and the number",
    )
    args = parser.parse_args()
    print(random_password(args.length, args.capitalize, args.special_char))
