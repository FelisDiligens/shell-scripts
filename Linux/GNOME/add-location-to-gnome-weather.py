#!/usr/bin/env python3

# Requirements: fzf
# pip packages: requests, iterfzf

# Based on https://gitlab.com/julianfairfax/scripts/-/blob/main/add-location-to-gnome-weather.sh


import math
import shutil
import subprocess
import sys
import requests
from iterfzf import iterfzf


def main():
    # Get GNOME Weather package type:
    is_system = False
    is_flatpak = False

    if shutil.which("gnome-weather"):
        is_system = True
    if shutil.which("flatpak"):
        flatpak_list = subprocess.check_output(["flatpak", "list", "--columns=application"]).decode("utf-8")
        if "org.gnome.Weather" in flatpak_list:
            is_flatpak = True
    if shutil.which("snap"):
        # TODO: Implement snap?
        print("Snap is installed but not supported by this script (yet).")

    if not is_system and not is_flatpak:
        print("GNOME Weather couldn't be found.")
        return 1

    # Query cities from OpenStreetMap API:
    query = input("Name of your city or location: ")
    response = requests.get(
        "https://nominatim.openstreetmap.org/search",
        params=[("q", query), ("format", "json"), ("limit", "10")])
    locations = response.json()

    selected_location = None
    if len(locations) == 0:
        print("No locations found.")
        return 1
    elif len(locations) == 1:
        print("Only 1 location found.")
        selected_location = locations[0]
    else:
        # Use fzf to let user select a city:
        formatted_locations = list(map(lambda l: "%s (%d)" % (l["display_name"], l["place_id"]), locations))
        fzf_result = iterfzf(formatted_locations)
        selected_index = formatted_locations.index(fzf_result)
        selected_location = locations[selected_index]

    # Check if user wants to proceed:
    if input("Do you want to add \"%s\" to GNOME Weather? [y/N] : " % selected_location["display_name"]).lower() != "y":
        print("Abort.")
        return 1
    
    # Format location for gsettings:
    name = selected_location["name"]
    lat = float(selected_location["lat"]) / (180 / math.pi)
    lon = float(selected_location["lon"]) / (180 / math.pi)
    gsettings_formatted_location = "<(uint32 2, <('%s', '', false, [(%f, %f)], @a(dd) [])>)>" % (name, lat, lon)

    # Add to GNOME Weather:

    if is_system:
        gsettings_locations = subprocess.check_output(["gsettings", "get", "org.gnome.Weather", "locations"]).decode("utf-8").strip()
        if gsettings_locations == "@av []":
            subprocess.check_call(["gsettings", "set", "org.gnome.Weather", "locations", "[" + gsettings_formatted_location + "]"])
        else:
            subprocess.check_call(["gsettings", "set", "org.gnome.Weather", "locations", gsettings_locations[:-1] + ", " + gsettings_formatted_location + "]"])
        print("Added to system's GNOME Weather")
    
    if is_flatpak:
        gsettings_locations = subprocess.check_output(["flatpak", "run", "--command=gsettings", "get", "org.gnome.Weather", "locations"]).decode("utf-8").strip()
        if gsettings_locations == "@av []":
            subprocess.check_call(["flatpak", "run", "--command=gsettings", "set", "org.gnome.Weather", "locations", "[" + gsettings_formatted_location + "]"])
        else:
            subprocess.check_call(["flatpak", "run", "--command=gsettings", "set", "org.gnome.Weather", "locations", gsettings_locations[:-1] + ", " + gsettings_formatted_location + "]"])
        print("Added to GNOME Weather flatpak")

    return 0


if __name__ == "__main__":
    sys.exit(main())