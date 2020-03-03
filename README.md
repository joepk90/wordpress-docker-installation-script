
# Before starting the script
Before running the wordpress-docker-install.sh install script, add your key to your ssh-agent by running the following command:

    shh-add

It is also advisable to backup the Kinsta install your intend to copy the database from (this is just a precaution)

Finally you will need the following requirements before starting the script. 

# required arguments:

    Directory Name: // name of the directory you want the project files to be located
    Repository Url: // for example: git@bitbucket.org:owner/repo.git
    Server IP or Domain: 
    Server User Name: 
    Server Port: 
    Server Path: 
    Database Name: // database name of your choice
    Site Domain: 
    Site Database Prefix: // for example: wp_


# make the install script executable
chmod +x wordpress-docker-installation-script/create-devilbox-install.sh

# run the install script
wordpress-docker-installation-script/create-devilbox-install.sh

# Enable caching in the .env file (Optional)
MOUNT_OPTIONS=,cached


# To enable multisite rewreite rules

# Enable the following line:
HTTPD_SERVER=apache-2.4

# Disable the following line:
HTTPD_SERVER=nginx-mainline

# TODO setup nginx config for mutlisites instead