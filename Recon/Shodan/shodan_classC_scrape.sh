ip=$1;
for x in $(seq 1 255);do 
 y=`echo $ip`.`echo $x`_output; # sets output filename
 z=`echo $ip`.`echo $x`; # sets iterated IP address
 wget -O $y https://www.shodan.io/host/`echo $z`; # makes wget call and saves results to disk
 done; # finish the for loop
find ./ -maxdepth 1 -size 0 -print0 | xargs -0 rm; # removes any file with size 0 (be careful)
# greps for specific line containing port numbers
# removes Contact information for cleaner output
# further cleaning of STDOUT for reading
grep "<li><a href=\"#" ./* |\
grep -v Contact |\
sed -r "s/(.*)_output\:<li><a href=\"#[0-9]{1,5}\">(.*)<\/a>/\1:\2/g"
