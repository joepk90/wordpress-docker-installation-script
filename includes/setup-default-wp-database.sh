# SHELL SCRIPT
# will be run from withon the docker shell
# starting directory: project/data/www/

if [ -n  "$1" ]
then
project_dir_name=$1
else
  exit 1
fi

if [ -n  "$2" ]
then
project_db_name=$2
else
  exit 1
fi

printf "\nentered the shell \n"
printf "\nmoving too ${project_dir_name}/htdocs/ \n"
cd ${project_dir_name}/htdocs/

# create wp-config.php file
printf "\nsetting up wordpress database \n"
wp config create --dbname=$project_db_name --dbuser=root --dbhost=127.0.0.1  --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

wp db create --dbuser=root --dbpass=""

exit 1