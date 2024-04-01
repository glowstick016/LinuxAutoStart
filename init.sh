#!/bin/bash

before_reboot(){
	echo "Configuring Ports"
		ufw allow 22/tcp
		ufw enable

	echo "Updating OS"
		apt update
		apt upgrade
		reboot
}

after_reboot(){
	echo "Type WIN.UDEL.EDU When prompted"
	sleep(5)
	echo "Installing dependencies"
		apt-get -y --ignore-missing install $(< package.list)
	clear
	sleep 1

	echo "Adding security"
		echo "#<ENGR>Disable broadcasting SNMP traffic to local network" >> /etc/cups/snmp.conf
		echo "#Address @LOCAL" >> /etc/cups/snmp.conf
		echo "Address 127.0.0.1" >> /etc/cups/snmp.conf

		declare -a tmpArr=("epson2.conf" "kodakaio.conf" "magicolor.conf")
		for i in ${tmpArr[@]};
		do
			echo "#<ENGR>Disable broadcasting SNMP traffic to local network" >> /etc/sane.d/$i
			echo "#net autodiscovery" >> /etc/sane.d/$i
		done
	
	echo "Acquiring Hostname"	
		sudo ./hostFunc.sh


}

echo "Script to setup Ubuntu 22.04"
read -p "Do you want to run this? [y/n]" yn

if [ "$yn" == "n" ];
        then
                exit
fi
if [ -f /var/run/rebootTmp ];
	then
		after_reboot
		rm /var/run/rebootTmp
	else
		before_reboot
		echo "Making temp file"
		touch /var/run/rebootTmp
fi


