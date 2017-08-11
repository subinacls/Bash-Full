#!/usr/bin/env bash
#
# ever wonder if there is a way to check found emails against haveibeenpwned ?
# Well there is through their API, which is demoed here for example
#
harvpwned() {
  checkresdir() {
    # checks if there is an existing directory to hold results
    # if not, make one and move all results to this dir
    if [ ! -d ./$1 ];
      then
        mkdir ./$1
        newdir="./$1"
    fi
  }
  theharv() {
    # runs the harvester against given domain using '-b all' argument limit of 1000 results
    # saves theharvester output as domain.harvester
    # greps out the domain target
    # looks for email addresses by the @ character
    # translates from Upper to Lower case
    # sorts unique and saved it to domain.email file
    theharvester -d $1 -b all -l 1000 > $newdir/$1.harvester && \
    cat $newdir/$1.harvester |\
      grep $1 |\
      grep "@" |\
      tr [:upper:] [:lower:] |\
      sort -u > $newdir/$1.emails;
  };
  hibp() {
    # sleeps a random timeframe to avoid abuse of API
    # runs wget on haveibeenpwned API2 with given email address
    # replaces any "," in the results with a newline
    # greps case-insensitive for the word title
    # cuts results at the first ":" character, returns 2nd column
    # cuts results at the first '"' character, returns 2nd column
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
  # checks for the evidence directory, make one if not found
  checkresdir $1;
  echo -e "\n[-] Running TheHarvester against $1\n"
  # runs the harvester function with given domain as the first argument
  theharv $1;
  echo -e "[-] Conducting email testing against haveibeenpwned.com\n\t[!] Results are listed below:\n"
  # iterates over the emails file and conducts wget request to haveibeenpwned.com, saves results
  # does a grep to remove any email addresses NOT found within the sites database
  for x in $(cat $newdir/$1.emails);
    do
      hibp $x
  done | grep -Ev "^(.*),$" > $newdir/$1.pwnedlist
  # prints results to STDOUT for easier access to information
  cat $newdir/$1.pwnedlist
  echo -e "[-] Finished\n"
};
# runs the main function
harvpwned $1
