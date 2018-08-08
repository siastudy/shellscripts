#!/bin/bash


#########bash version check
shversion=`sudo ls -l /bin/sh`
####dash not support: <<< ###
# IFS=' ' read str1 str2 str3 str4 str5 str6 str7 str8 str9 str10 str11 <<< $shversion
targetshVersion='bash'

if [ -n "${shversion##*$targetshVersion*}" ]; then
	echo "Alert!!! Default shell is \n $shversion ! \n But bash is needed!!"
	echo "\n"
	echo "You can switch shell version to bash by running: \n sudo dpkg-reconfigure dash"
	exit 2
fi

function prepareEnv(){
	# Install necessary apps
	pkglist[0]=apt-transport-https
	pkglist[1]=ca-certificates
	pkglist[2]=curl
	pkglist[3]=gnupg
	pkglist[4]=software-properties-common
	pkglist[5]=dirmngr

	for pkg in ${pkglist[@]}
	do
		pkgres=`dpkg -s $pkg 2>&1`
		
		if [[ $pkgres = *'is not installed'* ]]; then
			sudo apt-get -y install $pkg
		fi
		
	done

}

function installDocker(){

	## Get distribution version
	vres=`lsb_release  --id  --codename | cut -f2`
	# echo $vres-->Debian stretch

	# Convert version msg from uppercase to lowercase
	vres=`echo "$vres" | tr '[:upper:]' '[:lower:]'`

	# Replace space in string with '-'
	vres=`echo $vres | tr " " -`

	## install docker
	sudo sh -c "echo deb https://apt.dockerproject.org/repo $vres main > /etc/apt/sources.list.d/docker.list"
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
	sudo apt-get update
	sudo apt-get -y install docker-engine
}

function checkInstallationRes(){
	## Check installation:
	ires=`sudo docker info 2>&1`
	if [[ $ires = *'command not found'* ]]; then
		# echo '>>>>Docker Installation Failure or NOT Installed!'
		return -1
		elif [[ $ires = *'ontainers:'* ]]; then
			#echo '>>>>Docker Installation Succeed!!'
			return 1
	fi
	
}



#################main#######################



#########script body#############
sudo grep device-mapper /proc/devices

if [[ $res != *'device-mapper'* ]]; then
	sudo modprobe dm_mod
fi

res=`sudo grep device-mapper /proc/devices`

if [[ $res = *'device-mapper'* ]]; then
	echo 'device-mapper enabled! start installing docker!'
	
		checkInstallationRes
		if [[ $? = 1 ]]; then
			echo '>>>>Docker has already been installed!'
		else
			prepareEnv
			installDocker
			
			checkInstallationRes
			if [[ $? != 1 ]];then
				echo '>>>>Docker Installation Failure!'
			else
				echo '>>>Docker Installation Succeed!'
			fi
		fi

	else
		echo 'device-mapper not enabled! cannot install docker'
fi










