# $project_dir_name
# $project_db_name
# $kinsta_db_table_prefix
# $kinsta_domain

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

if [ -n  "$3" ]
then
kinsta_db_table_prefix=$3
else
  exit 1
fi

if [ -n  "$4" ]
then
kinsta_domain=$4
else
  exit 1
fi

#
# FUNCTIONS:
#

# function: check if database already exists
function does_db_exist {

  if mysql -h mysql -u root -e "use ${project_db_name}" 2> /dev/null;
  then

    # echo 'does exists'
    return 1 # database exists

  else
    # echo 'does not exist'
    return 0 # database does not exist'
  
  fi

}  

# function: import database
run_wp_import () {

  wp db import docker-db.sql

  # import using myql
  # mysql -h mysql -u root $project_db_name < docker-db.sql

  # find and replace domain in database
  wp search-replace "${kinsta_domain}"  "${project_dir_name}.loc" --all-tables --precise
}


#
# START SCRIPT:
#

cd ${project_dir_name}/htdocs/

# create wp-config.php file
wp config create --dbname=$project_db_name --dbuser=root --dbhost=127.0.0.1 --dbprefix=$kinsta_db_table_prefix --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

database_exists=$(does_db_exist)
overrite_existing_database=n

if [ "$database_exists" == 1 ]
then

  printf "\ndatabase already exists!\n"
  read -p 'do you want to continue importing the database? this will overwrite the current database: y/n' overrite_existing_database

else

  # if no database exists, create it and run the import
  wp db create --dbuser=root --dbpass=""
  run_wp_import

fi


if [ "$overrite_existing_database" == 'y' ]
then

  # if a database already exists, reset it and then run the import
  wp db reset --yes
  run_wp_import

fi


printf "\nimport complete \n"

rm docker-db.sql

exit 1