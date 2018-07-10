#!/usr/bin/env python
#
# takes a list of CIDR ranges and pulls the standard HTTPS port 443 to grab Domain names of the SSL Certificate installed / Used
#
# echo "1.2.3.0/24" > target_list
# python openssl_DNS.py target_list

import os
from netaddr import *
import sys
import multiprocessing

ips = list()
with open(sys.argv[1]) as ipfile:
 for xip in ipfile:
  ips.append(xip)

def openssl_process():
 cmd = 'echo | \
   timeout 2 openssl s_client -connect '+str(xnip)+':443 2>/dev/null | \
   openssl x509 -noout -text 2>/dev/null | \
   grep DNS: | \
   tr -d " \t" | \
   cut -d"." -f2-'
 print xnip, os.popen(cmd).readlines()

jobs = []
for nip in ips:
 for xnip in IPNetwork(nip):
  p = multiprocessing.Process(target=openssl_process)
  jobs.append(xnip)
  p.start()
 p.join()
