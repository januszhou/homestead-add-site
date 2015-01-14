# homestead-add-site
Automatically create new site on Homestead

## What does it do?
Everything that you have to do when you add new project to your Homestead VM:
* create project's folder
* edit /etc/hosts
* run serve command on VM
* edit Homestead.yaml file
* restart nginx server

## How to use?
1. Download the code
2. Make the file executable `chmod 755 addsite.sh`
3. Optionally change file's name to addsite `mv addsite.sh addsite` and move it to one of the folders in your PATH
4. Run in terminal where you can provide attributes directly:
```
addsite <project name> <folder path> <vagrant ip> <vagrant path>
```
...or if you don't provide the attributes, it will ask you about each one.

## Contribute
Please feel free to leave me comments and share your ideas. The code is not perfect, it has been tested only on Mac, so it might not work on your machine.

## Contact Author
Catch me on Twitter: [@raffw7912](https://twitter.com/raffw7912 "Twitter")
