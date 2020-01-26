read -p 'what is your user id (run id -u to find out)? ' user_id
read -p 'what is your user id (run id -g to find out)? ' user_group

read -p 'what is the name of your new projects directory? ' project_dir_name

# todo make repo cloing optional
# download_repo=false

read -p 'what is the URL of the repository you want to clone? ' project_repo_name

# todo make database import optional
# import_database=false


read -p 'what is the kinsta sites IP address? ' kinsta_ip
read -p 'what is the kinsta sites name? ' kinsta_name
read -p 'what is the kinsta sites port? ' kinsta_port
read -p 'what is the kinsta sites directory_path? ' kinsta_dir_path
# read -sp 'what is the kinsta sites SFTP password? ' kinsta_password


# testing
# echo $project_dir_name $project_db_name $project_repo_name $kinsta_domain $kinsta_ip $kinsta_name $kinsta_port $kinsta_dir_path $kinsta_password $kinsta_db_table_prefix

git clone https://github.com/cytopia/devilbox
mv devilbox $project_dir_name

cd $project_dir_name
cp env-example .env

# setup env file
# todo make this work automatically ithout providing them in the promt
# user_id=id -u
# user_group=id -g

# replace NEW_UID in .env file (using variables not yet tested)
sed -i '' "s/NEW_UID=1000/NEW_UID=${user_id}/g" .env

# replace NEW_GID in .env file (using variables not yet tested)
sed -i '' "s/NEW_GID=1000/NEW_GID=${user_group}/g" .env

# start devil box running (maybe turn this into a flag? -- start)
docker-compose up -d

# this could be done in one command...
mkdir -p data/www/$project_dir_name/htdocs
cd data/www/$project_dir_name/htdocs

# get project files from bitbucket repository
git clone $project_repo_name repository-files

# another flag or command might be required here to mv hidden files
mv repository-files/{.,}* ./
rm -rf repository-files/

# untested
# rm -rf repository-files

### currently FAILING at this point. It's ending up in the server and

# export database from kinsta install
# -o "StrictHostKeyChecking no" stops shh checking for authenticity of key fingerprint
echo "export database on kinsta server"
ssh -o "StrictHostKeyChecking no" $kinsta_name@$kinsta_ip -p $kinsta_port -t "cd $kinsta_dir_path; wp db export docker-db.sql; exit; bash"

# copy database to docker project directory
echo "copy database from kinsta server to local"
rsync -chavzP -e "ssh -p $kinsta_port" $kinsta_name@$kinsta_ip:$kinsta_dir_path/docker-db.sql ./
# rsync -chavzP -e ssh -p $kinsta_port $kinsta_name@$kinsta_ip:$kinsta_dir_path/docker-db.sql ./

# delete exported database on Kinsta server (clean up)
# -o "StrictHostKeyChecking no" stops shh checking for authenticity of key fingerprint
echo "clean up - delete database on kinsta server"
ssh -o "StrictHostKeyChecking no" $kinsta_name@$kinsta_ip -p $kinsta_port -t "cd $kinsta_dir_path; rm docker-db.sql; exit; bash"

### start temporary commands - a better solution should be worked ###

# go back to the orignal directory where script was running
cd ../../../../../

echo "making the wordpress-database-import script executable"
chmod +x wordpress-docker-installation-script/wordpress-database-import.sh

echo "copying wordpress-database-import script to project directory"
cp wordpress-docker-installation-script/wordpress-database-import.sh "${project_dir_name}/data/www/$project_dir_name/htdocs/"

echo "now run the following commands:"
echo "cd ${project_dir_name}"
echo "./shell.sh"
echo "cd ${project_dir_name}/htdocs"
echo "./wordpress-database-import.sh"

exit 1



### start temporary commands - a better solution should be worked ###

# TODO make the next steps run within this script

# go back to root docker directory
cd ../../../../
./shell.sh
cd "${project_dir_name}/data/www/${project_dir_name}/htdocs"

# create wp-config.php file
wp config create --dbname=$project_db_name --dbuser=root --dbhost=127.0.0.1 --dbprefix=$kinsta_db_table_prefix --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

# TODO could be better to use the CLI to import the database (wp db import). I had issues trying to do this last time

# import using myql
mysql -h mysql -u root -p '' $project_db_name < docker-db.sql

# find and replace domain in database
wp search-replace $kinsta_domain  "${project_dir_name}.loc" --all-tables --precise


# todo make the install script add this to your hosts
# sudo vi /etc/hosts
# 127.0.0.1 PROJECT_DIR_NAME.loc
