webrecursive() {
 wget $1 --no-check-certificate --page-requisites -r -t 1 -T 5; 
}
# recursive open folders of web evidence dir form crawled target site
# Extracts the HTTP(s) URI for mostly external sites.
# Useful when looking for specific sites like:
#    LinkedIN, Youtube, and other potential OSINT Resources
getextlinks() { 
 a=`for x in $(ls -aslR | grep -E "^.(.*)\:$" | grep ".:" | cut -d ":" -f1); do 
  echo $x;cat $x/* 2>/dev/nul |\
  tr -s " " "\n" |\
  grep -En "href(=| = |= )" |\
  sed -r "s/(.*)href=\"(.*)/\2/g" |\
  cut -d "'" -f2 |\
  grep -i http |\
  cut -d'"' -f1 |\
  sort -u ; \
 done | \
 grep -v "\./" |\
 grep http`;
 echo $a | \
 tr -s " " "\n" | \
 grep -Ev "${PWD##*/}" |\
 grep -v "tel:" |\
 grep -v "mailto:" |\
 grep -v "javascript:" |\
 grep -v href |\
 grep -vi hasclass | \
 sort -u |\
 tee external_links_`echo ${PWD##*/}`;
} ## cd ./web/targetname/ && getextlinks 
#
#
# examines a recursive download of a site and extracts the urls in relation to the site
# useful to find more information about the followings:
# entry point, folder layout, files hosted, technologies used ...
getintlinks() { 
 a=`for x in $(ls -aslR | grep -E "^.(.*)\:$" | grep ".:" | cut -d ":" -f1); do 
  echo $x;cat $x/* 2>/dev/nul |\
  tr -s " " "\n" |\
  grep -n "href=" |\
  sed -r "s/(.*)href=\"(.*)/\2/g" |\
  cut -d "'" -f2 |\
  grep -i http |\
  cut -d'"' -f1 |\
  sort -u ; \
 done | \
 grep -v "\./" |\
 grep http`;
 echo $a | \
 tr -s " " "\n" | \
 grep -v "tel:" |\
 grep -v "mailto:" |\
 grep -v "javascript:" |\
 grep -v href |\
 grep -vi hasclass | \
 sort -u |\
 tee internal_links_`echo ${PWD##*/}`;
} ## cd ./web/targetname/ && getinlinks 
#
#
# Takes the external_links file and processes it further to find external sites
# Gives a weight based on how many times a link from the external service provider
# has been seen within the site source code, this can be useful for OSINT
getweights() { 
 for x in $(cat $1 | cut -d "." -f1-3 | cut -d "/" -f3| sort -u); do \
  lines=$(grep $x $1 | wc -l); 
  echo -e "Weight: $lines\t$x"; 
 done |sort -t $' ' -k 2 -n;
} ## getextweight ./external_links_filename
