current_dir_path=$(pwd)

if [ -n "$user_id" ]
then
  echo "Your User ID is ${user_id}"
else
  read -p 'what is your user id (run id -u to find out)? ' user_id
fi

if [ -n "$user_group" ]
then
  echo "Your User Group is ${user_group}"
else
  read -p 'what is your user id (run id -g to find out)? ' user_group
fi

if [ -n "$project_dir_name" ]
then
  echo "Your Project directory name is ${project_dir_name}"
else
  read -p 'what is the name of your new projects directory? ' project_dir_name
fi


git clone https://github.com/cytopia/devilbox $project_dir_name
# mkdir $project_dir_name // testing

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




#
# option 1: setup a default Wordpress installation (including a database)
#

read -p 'Do you want to create a default Wordpress installation? (y/n) ' run_default_wp_installer

if [ "$run_default_wp_installer" == "y" ]
then
  echo "Running Wordpress installer. This will create a a new Wordpress database and install Wordpress"

  # go back to the orignal directory where script was running
  cd $current_dir_path

  echo "making the prepare-wordpress-install-script.sh script executable"
  chmod +x wordpress-docker-installation-script/includes/setup-default-wp-database.sh

  echo "copying wordpress-database-import script to project directory"
  cp wordpress-docker-installation-script/includes/setup-default-wp-database.sh "${project_dir_name}/data/www/"

  cd $project_dir_name/data/www/$project_dir_name/htdocs

  wget https://wordpress.org/latest.tar.gz
  tar -xzvf latest.tar.gz
  mv wordpress/* ./
  rmdir wordpress/
  rm latest.tar.gz

  cd $current_dir_path/$project_dir_name

  read -p 'what do you want to call your new projects database? ' project_db_name

  # run script within docker shell
  docker-compose exec --user devilbox php bash -l setup-default-wp-database.sh ${project_dir_name} ${project_db_name}

  cd $current_dir_path
  rm "${project_dir_name}/data/www/setup-default-wp-database.sh"

fi




#
# option 2: custom Wordpress repository clone
#


# check if default Wordpress install has been run
if [ "$run_default_wp_installer" == "n" ]
then
read -p 'Do you want to clone an exisiting wordpress repository? (y/n) ' run_clone_repository_script
fi

if [ "$run_clone_repository_script" == "y" ]
then

  # go back to the orignal directory where script was running
  cd $current_dir_path

  echo "making the clone-git-repository.sh script executable"
  chmod +x wordpress-docker-installation-script/includes/clone-git-repository.sh

  wordpress-docker-installation-script/includes/clone-git-repository.sh $project_dir_name

fi






#
# option 3: importing a Wordpress database
#

# check if default Wordpress install has been run
if [ "$run_default_wp_installer" == "n" ]
then
read -p 'Do you want to import a database from a server? (y/n) ' run_server_db_importer
fi


if [ "$run_server_db_importer" == "y" ]
then

cd $current_dir_path
cd data/www/$project_dir_name/htdocs

read -p 'what do you want to call your new projects database? ' project_db_name
read -p 'what is the server sites IP address? ' server_ip
read -p 'what is the server sites name? ' server_name
read -p 'what is the server sites port? ' server_port
read -p 'what is the server sites directory_path? ' server_dir_path
read -p 'what is the domain of the server site? ' server_domain
read -p 'what is the server sites database table prefix (for example: wp_)? ' server_db_table_prefix

echo "making the clone-server-database.sh script executable"
chmod +x wordpress-docker-installation-script/includes/clone-server-database.sh $server_ip $server_name $server_port $server_dir_path $server_domain $server_domain
 
echo "copying clone-server-database.sh script to project directory"
cp wordpress-docker-installation-script/includes/import-server-database.sh "${project_dir_name}/data/www/"

cd $current_dir_path/$project_dir_name

# run script within docker shell
docker-compose exec --user devilbox php bash -l import-server-database.sh $project_dir_name $project_db_name $kinsta_db_table_prefix $kinsta_domain

fi




#
# update the /etc/hosts file
#

echo "making the update-hosts.sh script executable"
chmod +x wordpress-docker-installation-script/includes/update-hosts.sh

wordpress-docker-installation-script/includes/update-hosts.sh $project_dir_name

printf "\nDevilbox Install script complete! \n"
printf "\nnow visit ${project_dir_name}.loc\n"
