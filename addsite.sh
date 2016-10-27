#!/bin/bash
echo
echo "Simple way to add nginx sites to Homestead"
echo "Use: addsite <project name> <folder path> <vagrant ip> <vagrant path>"
echo

################ UPDATE HERE ###########################
vagrantIp="192.168.10.10" # change it if you set different vagrant box ip address
baseVagrantPath="/home/vagrant/Code" # mapped vagrant box folder path
baseProjectPath="/Users/zhou/public_html" # local folder path
baseHomesteadFolder="/Users/zhou/.homestead" # homestead yaml file path
homesteadPath="/Users/zhou/public_html/Homestead" # homestead vagrant file path, where you usually run vagrant up & halt
################ UPDATE HERE ###########################

function lowercase {
	lowercased=`echo $1 | tr '[A-Z]' '[a-z]'`
}

if [ -z "$1" ]
	then
		echo -n "Please enter site's name (for example project1.app): "
		read answer
	else
		answer="$1"
fi

siteName="$answer"

if [ -z "$2" ]
	then
		echo
		echo "Path to site's public directory on host machine. "
		echo "Path will be prefixed with your config. "
		echo -n "Folder to use: "
		read answer
	else
		answer="$2"
fi

vSiteFolder="$baseVagrantPath/$answer/"
siteFolder="$baseProjectPath/$answer/"

echo "Editing hosts file (You might be asked to provide your user's password for host machine)..."
# edit hosts file
echo -e "\n$vagrantIp $siteName" | sudo tee -a /etc/hosts

echo "Editing Homestead.yaml file ..."
# edit Homestead.yaml
if [ -e "$baseHomesteadFolder/Homestead.yaml" ]
	then
		file="$baseHomesteadFolder/Homestead.yaml"
	else
		echo "\n Homestead.yaml file path error"
		exit 1
fi

siteFolderLength=${#siteFolder}
endLength=$[$siteFolderLength-7]
sFolder="$siteFolder"

# if [ ${siteFolder:(-7)}  == "/public" ]
# 	then
# 		sFolder=${siteFolder:0:$endLength}
# 		affix="/public"

# 		vSiteFolderLength=${#vSiteFolder}
# 		vEndLength=$[$vSiteFolderLength-7]
# 		vSiteFolderShort=${vSiteFolder:0:$vEndLength}
# fi

cd "$baseHomesteadFolder"

awk -v from="sites:.*$" -v to="sites:\n    - map: $siteName\n      to: $vSiteFolder" '{gsub(from,to,$0); print $0}' ${file} > ${file}.new

echo "Removing temp files ..."
mv ${file}.new $file

cd $homesteadPath
echo "Restarting your Homestead VM..."
vagrant reload --provision

echo "All done! Thank you!"
echo
