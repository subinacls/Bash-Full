ip=$1;
for x in $(seq 1 255);do 
 y=`echo $ip`.`echo $x`_output;
 z=`echo $ip`.`echo $x`;
 wget -O $y https://www.shodan.io/host/`echo $z`;
 done;
find ./ -size 0 -print0 | xargs -0 rm;
grep "<li><a href=\"#" ./* |\
grep -v Contact |\
sed -r "s/(.*)_output\:<li><a href=\"#[0-9]{1,5}\">(.*)<\/a>/\1:\2/g"
