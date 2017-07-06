ip=$1;
mkdir $ip 2&>/dev/null;
echo -e "[!] Class C Shodan Scraper\n  By: SubINaclS - 2017\n";
for x in $(seq 1 255);do 
 y="./`echo $ip`/`echo $ip`.`echo $x`_output"; # sets output filename
 z=`echo $ip`.`echo $x`; # sets iterated IP address
 echo -e "\t[*] Scraping: `echo $z`";
 wget -O $y https://www.shodan.io/host/`echo $z` 2&>/dev/null; # makes wget call and saves results to disk
 done; # finish the for loop
find ./`echo $ip` -maxdepth 1 -size 0 -print0 | xargs -0 rm; # removes any file with size 0 (be careful)
# greps for specific line containing port numbers
# removes Contact information for cleaner output
# further cleaning of STDOUT for reading
echo -e "\n[!] Finishing, Results as follows:";
grep "<li><a href=\"#" ./`echo $ip`/* |\
grep -v Contact |\
sed -r "s/(.*)_output\:<li><a href=\"#[0-9]{1,5}\">(.*)<\/a>/\1:\2/g"
