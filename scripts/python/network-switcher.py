#!/usr/bin/python3

# This script automatically switches the wifi connection to the AP with
# the strongest signal (chosen from APs known to network manager)
# Uses nmcli, see https://developer.gnome.org/NetworkManager/stable/nmcli.html

import sys
import getopt
import subprocess
import pprint

#set the switching threshold. Signal strength returned by NM
# is on a scale of 0-100
MIN_SIGNAL_STRENGTH_DIFFERENCE_FOR_SWITCHING=12

#variable list
active_connection=""
potential_switching_candidates={}
pp = pprint.PrettyPrinter(indent=4)
verbose = False

# get command line overrides

options, remainder = getopt.getopt(sys.argv[1:], 'v', ['verbose'])

for opt, arg in options:
    if opt in ('-v', '--verbose'):
        verbose = True

#function that returns the signal strength from a scan result passed to it
def signal_strength_sort_key(available_network):
    return available_network.split(":")[1] #the signal strength is in the 2nd column

#get a list of networks in range
network_scan_info = subprocess.run(
        ["/usr/bin/nmcli",
            "-t", #tabular format, with : as separator
            "-f", #choose columns included in result
            "ssid,signal,rate,in-use",
            "dev",
            "wifi",
            "list"],
        stdout = subprocess.PIPE,
        universal_newlines = True)

#store the output in a list, where each line
#contains the results for a single network
available_networks=network_scan_info.stdout.splitlines()

#get a list of networks known to this system
known_networks_info = subprocess.run(
        ["/usr/bin/nmcli",
            "-t",
            "-f",
            "name",
            "connection",
            "show"],
        stdout = subprocess.PIPE,
        universal_newlines = True)
 
#store the names (=SSID) of each known network in a list
known_networks=known_networks_info.stdout.splitlines()

if verbose:
    print('Available:')
    pp.pprint(available_networks)

if verbose:
    print('Known:')
    pp.pprint(known_networks)

#save the common set of networks between available and known
#also save the info of the currently active wifi connection
for network in available_networks:
    network_info=network.split(":")
    ssid=network_info[0]
    active=False
    if network_info[3]=='*': #4th column stores "*" if network in use
        active=True
        active_connection=network
    valid_ssid = next((s for s in known_networks if ssid in s), None)
    if valid_ssid:
        potential_switching_candidates[valid_ssid] = network
        
print('Potential:')
pp.pprint(potential_switching_candidates)
print('Active:')
pp.pprint(active_connection)

#sort the list by weakest to strongest signals (if not empty)
if potential_switching_candidates:
    candidates = list(potential_switching_candidates.values())
    candidates.sort(key=signal_strength_sort_key)
    #switch to network with best signal strength
    strongest_available_network=candidates[-1]
    strongest_network_info=strongest_available_network.split(":")
    strongest_name=strongest_network_info[0]
    strongest_signal=strongest_network_info[1]
    #if there is an active connection, get the signal strength, else 0
    if active_connection:
        current_signal_strength=active_connection.split(":")[1]
        print('Signal strengths:')
        print(current_signal_strength)
    else:
        current_signal=0
    if verbose:
        print('Strongest signal, current signal: ', strongest_signal, current_signal_strength)
    # Do the actual switch to the stronger network
    if int(strongest_signal) > int(current_signal_strength)+MIN_SIGNAL_STRENGTH_DIFFERENCE_FOR_SWITCHING:
        subprocess.run(
             ["/usr/bin/nmcli",
                    "device",
                    "wifi",
                    "connect",
                    strongest_name])