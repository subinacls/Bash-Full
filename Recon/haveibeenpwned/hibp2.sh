#!/usr/bin/env bash
#
# ever wonder if there is a way to check found emails against haveibeenpwned ?
# Well there is through their API, which is demoed here for example
#
hibp() { 
  # sleeps a random timeframe to avoid abuse of API
  # runs wget on haveibeenpwned API2 with given email addres
  # replaces any "," in the results with a newline
  # greps case-insensitive for the word title
  # cuts results at the first ":" character, returns 2nd column
  # cuts results at the first '"' character, returns 2nd column
  # xargs echo the given email address and any results from query
  sleep `echo ${RANDOM} |\
    sed -r "s/([0-9])(.*)/\1/g"` ; 
  wget -o /dev/null -O - --user-agent="HIBP Validator" \
    "https://haveibeenpwned.com/api/v2/breachedaccount/$1" |\
    tr -s "," "\n" |\
    grep -i title |\
    cut -d":" -f2 |\
    cut -d'"' -f2
};
echo -e "[-] Conducting email testing against haveibeenpwned.com\n\t[!] Results are listed below:\n"
hibp $x 
echo -e "[-] Finished\n"
