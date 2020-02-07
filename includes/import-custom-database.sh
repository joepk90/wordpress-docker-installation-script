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

# create wp-config.php file
wp config create --dbname=$project_db_name --dbuser=root --dbhost=127.0.0.1 --dbprefix=$kinsta_db_table_prefix --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

# TODO could be better to use the CLI to import the database (wp db import). I had issues trying to do this last time

wp db create --dbuser=root --dbpass=""

# import using myql
mysql -h mysql -u root $project_db_name < docker-db.sql

# find and replace domain in database
wp search-replace "${kinsta_domain}"  "${project_dir_name}.loc" --all-tables --precise

echo "import complete"

rm wordpress-database-import.sh