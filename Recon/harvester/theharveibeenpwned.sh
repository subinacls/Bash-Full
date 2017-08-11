#!/usr/bin/env bash
#
# ever wonder if there is a way to check found emails against haveibeenpwned ?
# Well there is through their API, which is demoed here for example
#
harvpwned() { 
  theharv() {
    # saves all files to current working directory
    # runs the harvester against given domain
    # saves theharvester output as domain.harvester
    # greps out the domain target
    # looks for email addresses by the @ character
    # sourts unique and saved it to domain.email file
    theharvester -d $1 -b all -l 500 > $1.harvester &&\
    cat $1.harvester |\
      grep $1 |\
      grep "@" |\
      sort -u > $1.emails; 
  }; 
  hibp() { 
    # sleeps a random timeframe to avoid abuse of API
    # runs wget on haveibeenpwned API2 with given email addres
    # replaces an , in the results with a newline
    # greps insensitive for the word title
    # cuts results at the first ":" character
    # cuts results at the first '"' character
    # xargs echo the given email address and any results from query
    sleep `echo ${RANDOM} |\
      sed -r "s/([0-9])(.*)/\1/g"` ; 
    wget -o /dev/null -O - --user-agent="TheHarvester HIBP Validator" \
      "https://haveibeenpwned.com/api/v2/breachedaccount/$1" |\
      tr -s "," "\n" |\
      grep -i title |\
      cut -d":" -f2 |\
      cut -d'"' -f2 |\
      xargs echo $1,;
  };
  # runs the harvester function with given domain
  echo -e "\n[-] Running TheHarvester against $1\n"
  theharv $1; 
  for x in $(cat $1.emails) ;
    do 
      echo -e "\t[!] Testing email address $1"
      hibp $x 
  done | tee $1.pwnedlist;
  echo -e "[-] Finished\n"
};
harvpwned $1
