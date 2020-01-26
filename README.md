# required arguments:
User ID: // run $ id -u
User Group: // run $ id -g
Directory Name: // name of the directory you want the project files to be located
Repository Url: // for example: git@bitbucket.org:owner/repo.git
Kinsta IP: 
Kinsta Name: 
Kinsta Port: 
Kinsta Path: 
Database Name:
Kinsta Domain: 
Kinsta Database Prefix: // for example: wp_


# copy bash script to your projects directory (or wherever you keep you ant to keep your docker environemnts)
cp wordpress-docker-installation-script/wordpress-docker-install.sh ./

# make the install script executable
chmod +x wordpress-docker-installation-script/wordpress-docker-install.sh

# run the install script
wordpress-docker-installation-script/wordpress-docker-install.sh


TODO: add echo statements to describe process - helpful for debugging