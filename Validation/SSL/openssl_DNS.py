import os
from netaddr import *
import sys
import multiprocessing
import __builtin__ as bi

try:
 ips = list()
 with open(sys.argv[1]) as ipfile:
  for xip in ipfile:
   ips.append(xip)
except:
 pass

def openssl_process():
 try:
  cmd = 'echo | \
   timeout 2 openssl s_client -connect '+str(xnip)+':443 2>/dev/null | \
   openssl x509 -noout -text 2>/dev/null | \
   grep DNS: | \
   tr -d " \t" | \
   cut -d"." -f2-'
  res = os.popen(cmd).readlines()
  if res:
   nlist = list()
   reslist = [r.strip().replace('DNS:','') for r in res]
   for xres in reslist:
    for xs in xres.split(','):
     nlist.append(xs)
    for xso in sorted(set(nlist)):
     print('{}\t{}'.format(xnip, xso))
 except Exception as e:
  print e


try:
 jobs = []
 for nip in ips:
  for xnip in IPNetwork(nip):
   p = multiprocessing.Process(target=openssl_process)
   jobs.append(xnip)
   p.start()
  p.join()
except:
 pass
