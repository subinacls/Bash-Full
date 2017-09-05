
target_cidr="66.151.130.0/24"

checkmsfsshdir() {
 msfs="/usr/share/metasploit-framework/scripts/"
 msfs="/usr/share/metasploit-framework/scripts/"
 # checks if there is an existing directory to hold results
 # if not, make them as needed for this function
 if [ ! -d $msfs/ssh ]; then
  mkdir $msfs/ssh
 fi
 msfssh="$msfs/ssh"
}
ssh_version_rc() { `# build out the ssh_version scanner rc file with new target`
 echo "use auxiliary/scanner/ssh/ssh_version" > $msfssh/ssh_version.rc
 echo "set RHOSTS   $target_cidr" >> $msfssh/ssh_version.rc
 echo "set RPORT    22" >> $msfssh/ssh_version.rc
 echo "set THREADS  50" >> $msfssh/ssh_version.rc
 echo "set TIMEOUT  10" >> $msfssh/ssh_version.rc
 echo "set SHOWPROGRESS  FALSE" >> $msfssh/ssh_version.rc
 echo "set CONNECTTIMEOUT 10" >> $msfssh/ssh_version.rc
 echo "run" >> $msfssh/ssh_version.rc
 echo "exit" >> $msfssh/ssh_version.rc
 sshvrc="$msfssh/ssh_version.rc"
}
makeXtermLog() {
 if [ -f $1-log.txt ]; then
  rm $1-log.txt >/dev/null;
 fi;
 xterm -bc \
  -bd white \
  -bg black \
  -fg green \
  -l \
  -lf $1-log.txt \
  -leftbar \
  -ls \
  -name $1 \
  -ms yellow \
  -selbg orange \
  -selfg black \
  -title $1 \
  -e "$2"; 
}
ssh_version_kickoff() {
 (checkmsfsshdir)
 (ssh_version_rc)
 (makeXtermLog "MSF-SSH_Version_Scanner_Module" "msfconsole -r $msfssh/ssh_version.rc")
}
ssh_version_kickoff




 



