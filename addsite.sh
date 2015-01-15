#!/bin/bash
echo
echo "Simple way to add nginx sites to Homestead"
echo "Use: addsite <project name> <folder path> <vagrant ip> <vagrant path>"
echo


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
		echo "Path will be prefixed with your home directory. "
		echo -n "Folder to use: "
		read answer
	else
		answer="$2"
fi

vSiteFolder="/home/vagrant/$answer"
siteFolder="$(pwd)/$answer"

if [ -z "$3" ]
	then
		echo
		echo "Homestead's IP address "
		echo -n "(leave blank for 192.168.10.10): "
		read answer

		if [ -z "$answer" ]
			then
				answer="192.168.10.10"
		fi

	else
		answer="$3"
fi

vagrantIp="$answer"

if [ -z "$4" ]
	then
		echo "Homestead's folder path "
		echo -n "(leave blank for $(pwd)/Code/Homestead): "
		read answer

		if [ -z "$answer" ]
			then
				answer="$(pwd)/Code/Homestead"
		fi

	else
		answer="$4"
fi

vagrantPath="$answer"

# create folder if project doesn't exist
echo
echo "Creating folder $siteFolder ..."
mkdir -p "$siteFolder"

echo "Connecting to Homestead ..."
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no vagrant@127.0.0.1 -p 2222 "sudo bash /vagrant/scripts/serve.sh $siteName $vSiteFolder"

echo "Editing hosts file (You might be asked to provide your user's password for host machine)..."
# edit hosts file
echo -e "\n$vagrantIp $siteName" | sudo tee -a /etc/hosts

echo "Editing Homestead.yaml file ..."
# edit Homestead.yaml
if [ -e "$(pwd)/.homestead/Homestead.yaml" ]
	then
		file="$(pwd)/.homestead/Homestead.yaml"
	else
		file="$vagrantPath/Homestead.yaml"
fi

siteFolderLength=${#siteFolder}
endLength=$[$siteFolderLength-7]
sFolder="$siteFolder"

if [ ${siteFolder:(-7)}  == "/public" ]
	then
		sFolder=${siteFolder:0:$endLength}
		affix="/public"

		vSiteFolderLength=${#vSiteFolder}
		vEndLength=$[$vSiteFolderLength-7]
		vSiteFolderShort=${vSiteFolder:0:$vEndLength}
fi

awk -v from="folders:.*$" -v to="folders:\n    - map: $sFolder\n      to: $vSiteFolderShort" '{gsub(from,to,$0); print $0}' $file > ${file}.new
awk -v from="sites:.*$" -v to="sites:\n    - map: $siteName\n      to: $vSiteFolder" '{gsub(from,to,$0); print $0}' ${file}.new > ${file}.new2

echo "Removing temp files ..."
rm -f ${file}.new
mv ${file}.new2 $file

echo "Restarting your Homestead VM..."
homestead halt && homestead up

echo "All done! Thank you!"
echo
