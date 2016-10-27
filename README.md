# homestead-add-site
Automatically create new site on Homestead

## What does it do?
Everything that you have to do when you add new project to your Homestead VM:
* create project's folder
* edit /etc/hosts
* edit Homestead.yaml file
* reload & provision vagrant box

## How to use?
1. Download the code
2. Make the file executable `chmod 755 addsite.sh`
3. Edit addsite.sh, update base path config
4. Run in terminal where you can provide attributes directly:
```
addsite <project name> <folder relative path>
```
...or if you don't provide the attributes, it will ask you about each one.

#### Editable config:
```
################ UPDATE HERE ###########################
vagrantIp="192.168.10.10" # change it if you set different vagrant box ip address
baseVagrantPath="/home/vagrant/Code/" # mapped vagrant box folder path
baseProjectPath="/Users/zhou/public_html/" # local folder path
baseHomesteadFolder="/Users/zhou/.homestead" # homestead yaml file path
homesteadPath="/Users/zhou/public_html/Homestead" # homestead vagrant file path, where you usually run vagrant up & halt
################ UPDATE HERE ###########################
```

#### Example
```
./addsite.sh homestead.app homestead/public # locate to your index.php file
```

Based on config above, the script process as below:
1. Add `192.168.10.10 homestead.app` to /etc/hosts
2. Add `map: /map: homestead.app to: /home/vagrant/Code/homestead/public/` to `Homestead.yaml` file located at `"/Users/zhou/.homestead"`
3. Cd to `/Users/zhou/public_html/Homestead`, and run `vagrant reload --provision`

That's it, your new homestead.app is all set.

## Contribute
This repo clone from https://github.com/raffw7912/homestead-add-site.
