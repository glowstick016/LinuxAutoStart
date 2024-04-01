#!/bin/bash

deviceName(){
	echo "Getting the proper hostname of the device"
	while IFS= read -r line
	do
		echo "$line"
	done < Department.txt
	tmp=""

	#Match this up now
	read -p "Which number is the department:" tmp
	
	if [[ ! $tmp =~ ^[0-9]+$ ]]; then
		echo "Not a valid number"
		deviceName
	fi
	local dept="$(head -n $tmp Department.txt | tail -n 1 | cut -f2 -d":")" 
	
	echo -n $dept > Host.txt
	echo -n "-" >> Host.txt
	
	#Getting right OU value
	echo -n "computer-ou = ou=Client-Linux," > OU.txt
	echo -n "ou=" >> OU.txt
	echo -n $dept >> OU.txt
	echo ",ou=engr,ou=university,dc=win,dc=udel,dc=edu" >> OU.txt

	local res=$(getLD)
	echo -n $res >> Host.txt	
	
	#Getting service tag
	local service="$(dmidecode -s system-serial-number | tail -n 8)"
	echo $service >> Host.txt 

	dept=$dept-$res$service	

	echo "#ENGR localhost" >> /etc/hosts
	echo -n "127.0.0.1	" >> /etc/hosts
	echo -n $dept >> /etc/hosts
	echo "" >> /etc/hosts

	sudo hostnamectl set-hostname $dept --static
}

getLD(){
	read -p "Is this a Laptop (L) or Desktop (D):" tmp
	if [ "$tmp" ==  "L" ]; then
		echo L
	elif [ "$tmp" ==  "D" ]; then
		echo D
	else
		clear >$(tty)
		echo "Bad Input"
		tmp=""
		getLD
	fi
}

deviceName
