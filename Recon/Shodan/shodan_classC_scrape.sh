echo -e "[!] Class C Shodan Scraper\n  By: SubINaclS - 2017\n";
################################################################################
## Usage:
##  Dump to STDOUT
##    ./shodan_classC_scraper.sh 192.168.100 
##  Save to file
##    ./shodan_classC_scraper.sh 192.168.100 > saved_results.txt
################################################################################
ip=$1;
mkdir $ip 2&>/dev/null;
for x in $(seq 1 255);do 
 # sets output filename
 y="./`echo $ip`/`echo $ip`.`echo $x`_output";
 # sets iterated IP address
 z=`echo $ip`.`echo $x`;
 echo -e "\t[*] Scraping: `echo $z`";
 # makes wget call and saves results to disk
 wget -O $y https://www.shodan.io/host/`echo $z` 2&>/dev/null; 
 # finish the for loop
 done;
# removes any file with size 0 (be careful)
find ./`echo $ip` -maxdepth 1 -size 0 -print0 | xargs -0 rm; 
echo -e "\n[!] Finishing, Results as follows:";
# greps for specific line containing port numbers
# removes Contact information for cleaner output
# further cleaning of STDOUT for reading
grep "<li><a href=\"#" ./`echo $ip`/* |\
grep -v Contact |\
sed -r "s/(.*)_output\:<li><a href=\"#[0-9]{1,5}\">(.*)<\/a>/\1:\2/g"
# Users be aware, using this script will delete files on your system
################################################################################
