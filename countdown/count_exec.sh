#
# function to automatically run a command after a count down period
#
countdown() { 
 seconds=$1;
 date1=$((date +%s + $seconds));
 while [ "$date1" -ge date +%s ]; do
  echo -ne "$(date -u --date @$(($date1 - date +%s )) +%H:%M:%S)\r";
 done;
 $2;
} ## countdown 1800 'systemctl stop ssh'

# startup and countdown
sshupanddown() { 
 seconds=$1;
 cmdup="systemctl start ssh"
 cmddown="systemctl stop ssh"
 $cmdup
 date1=$((date +%s + $seconds));
 while [ "$date1" -ge date +%s ]; do
  echo -ne "$(date -u --date @$(($date1 - date +%s )) +%H:%M:%S)\r";
 done;
 $cmddown;
} ## sshupanddown 1800
