
# Before starting the script
Before running the wordpress-docker-install.sh install script, add your key to your ssh-agent by running the following command:

    shh-add

It is also advisable to backup the Kinsta install your intend to copy the database from (this is just a precaution)

Finally you will need the following requirements before starting the script. 

# required arguments:

    User ID: // run $ id -u
    User Group: // run $ id -g
    Directory Name: // name of the directory you want the project files to be located
    Repository Url: // for example: git@bitbucket.org:owner/repo.git
    Kinsta IP: 
    Kinsta Name: 
    Kinsta Port: 
    Kinsta Path: 
    Database Name: // database name of your choice
    Kinsta Domain: 
    Kinsta Database Prefix: // for example: wp_


# make the install script executable
chmod +x wordpress-docker-installation-script/wordpress-docker-install.sh

# run the install script
wordpress-docker-installation-script/wordpress-docker-install.sh


TODO: add echo statements to describe process - helpful for debugging