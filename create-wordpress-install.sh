cd ${project_dir_name}/htdocs/

read -p 'what do you want to call your new projects database? ' project_db_name

wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress/* ./
rmdir wordpress/
rm latest.tar.gz

# create wp-config.php file
wp config create --dbname=$project_db_name --dbuser=root --dbhost=127.0.0.1  --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

wp db create --dbuser=root --dbpass=""

exit 1
