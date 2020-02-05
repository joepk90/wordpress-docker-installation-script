read -p 'what is the name of your new projects directory? ' project_dir_name
read -p 'what do you want to call your new projects database? ' project_db_name
read -p 'what is the domain of the kinsta site? ' kinsta_domain
read -p 'what is the kinsta sites database table prefix (for example: wp_)? ' kinsta_db_table_prefix




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

printf "Finally exit the docker shell and add the following enry to your host file. run the following commands:\n"
printf "exit\n"
printf "sudo vim /etc/hosts\n"
printf "127.0.0.1 ${project_dir_name}.loc\n"
