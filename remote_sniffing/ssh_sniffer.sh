#!/usr/bin/env bash
# Written by: William no1special Coppola
# Sniff remote connections over SSH
################################################################################
# Command Usage:
################################################################################
#
#  This script uses the following logig:
#     argument1: The remote interface to sniff
#     argument2: The remote host you are going to ssh to
#     optional3: The PEM file used for SSH authentication
#
#     With PEM:
#         ssh_sniffer.sh eth0 testuser@somehost.tld ./yourfile.pem
#     Without PEM:
#         ssh_sniffer.sh eth0 testuser@somehost.tld
################################################################################
# Requirements:
################################################################################
#     Remote system needs to have tcpdump installed, uses sudo to accomplish this
#     Make sure the user is in the sudoers group
################################################################################
# Start Script:
################################################################################
# start SSH connection attempt
if [ "$1" == "" ]; then
 echo
 echo " Usage:"
 echo "    Outline: $0 <interface> <user@hostname> <PEM file>"
 echo "        W/ PEM:  $0 eth0 testuser@somehost.tld ./yourfile.pem"
 echo "    Outline: $0 <interface> <user@hostname>"
 echo "        W/O PEM: $0 eth0 testuser@somehost.tld"
 echo
 exit 1
fi;
if [ "$3" != "" ]; then
  # if there are three arguments supplied at command line use this command
  # make temp file and save as variable $a
  a=`tempfile`
  # remove temp file from system
  rm $a
  # make fifo pipe with temp file name saved in variable $a
  mkfifo $a
  # start wireshark and use the variable $a as a named pipe interface
  (wireshark -k -i $a &)
  (ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
    $2 -i $3  "sudo tcpdump -s 0 -U -n -w - -i $1 not port 22" > $a &)
else
  # if there are two arguments supplied at command line use this command
  # make temp file and save as variable $a
  a=`tempfile`
  # remove temp file from system
  rm $a
  # make fifo pipe with temp file name saved in variable $a
  mkfifo $a
  # start wireshark and use the variable $a as a named pipe interface
  (wireshark -k -i $a &)
  (ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
   $2 "sudo tcpdump -s 0 -U -n -w - -i $1 not port 22" > $a &)
fi
