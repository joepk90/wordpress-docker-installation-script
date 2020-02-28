current_dir_path=$(pwd)

if [ -n "$docker_dir_name" ]
then
  echo "Your docker directory is: ${docker_dir_name}"
else
  read -p 'What is the directory name of the Docker environment? ' docker_dir_name
fi


if [ -n "$project_dir_name" ]
then
  echo "Your Project directory name is ${project_dir_name}"
else
  read -p 'what is the name of your new projects directory? ' project_dir_name
fi

#
# setup utilities:
#

# setup executable shell script
chmod +x wordpress-docker-installation-script/includes/prepare-shell-script.sh


#
# start install:
#


# install and configure docker
chmod +x wordpress-docker-installation-script/includes/configure-docker.sh
wordpress-docker-installation-script/includes/configure-docker.sh ${docker_dir_name} ${project_dir_name}



#
# option 1: setup a default Wordpress installation (including a database)
#

read -p 'Do you want to create a default Wordpress installation? (y/n) ' run_default_wp_installer

if [ "$run_default_wp_installer" == "y" ]
then
  echo "Running Wordpress installer. This will create a a new Wordpress database and install Wordpress"

  # go back to the orignal directory where script was running
  cd $current_dir_path

  read -p 'what do you want to call your new projects database? ' project_db_name

  # prepare and run clone-default-wp-repository.sh shell script
  wordpress-docker-installation-script/includes/prepare-shell-script.sh ${docker_dir_name} "clone-default-wp-repository.sh"
  
  # prepare and run setup-default-wp-database.sh shell script
  wordpress-docker-installation-script/includes/prepare-shell-script.sh ${docker_dir_name} "setup-default-wp-database.sh"

  cd ${docker_dir_name}

  # run shell scripts
  docker-compose exec --user devilbox php bash -l clone-default-wp-repository.sh ${project_dir_name}
  docker-compose exec --user devilbox php bash -l setup-default-wp-database.sh ${project_dir_name} ${project_db_name}

  # prepare and run create-wordpress-install.sh shell script
  # wordpress-docker-installation-script/includes/prepare-shell-script.sh ${project_dir_name} "create-wordpress-install.sh"
  # docker-compose exec --user devilbox php bash -l create-wordpress-install.sh ${project_dir_name} ${project_db_name}

  # remove shell scripts
  cd $current_dir_path
  rm "${docker_dir_name}/data/www/clone-default-wp-repository.sh"
  rm "${docker_dir_name}/data/www/setup-default-wp-database.sh"

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

  wordpress-docker-installation-script/includes/clone-git-repository.sh $docker_dir_name $project_dir_name

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

read -p 'what do you want to call your new projects database? ' project_db_name
read -p 'what is the server sites IP address or domain? ' server_ip
read -p 'what is the name of the server user? ' server_user_name
read -p 'what is the server sites port? ' server_port
read -p 'what is the server sites directory_path? ' server_dir_path
read -p 'what is the domain of the site you are cloning? ' server_domain
read -p 'what is the server sites database table prefix (for example: wp_)? ' server_db_table_prefix

# todo it's not neccesary to copy it here (so the rm command should also be removed when this is fixed)
# prepare and run clone-default-wp-repository.sh shell script
wordpress-docker-installation-script/includes/prepare-shell-script.sh ${docker_dir_name} "clone-server-database.sh"

# prepare and run setup-default-wp-database.sh shell script
wordpress-docker-installation-script/includes/prepare-shell-script.sh ${docker_dir_name} "import-custom-database.sh"

# run script within docker shell
wordpress-docker-installation-script/includes/clone-server-database.sh $current_dir_path $docker_dir_name $project_dir_name $server_ip $server_user_name $server_port $server_dir_path $server_domain
# docker-compose exec --user devilbox php bash -l clone-server-database.sh $current_dir_path $project_dir_name $server_ip $server_user_name $server_port $server_dir_path $server_domain

cd $docker_dir_name
docker-compose exec --user devilbox php bash -l import-custom-database.sh $project_dir_name $project_db_name $server_db_table_prefix $server_domain

# remove shell scripts
cd $current_dir_path
rm "${docker_dir_name}/data/www/clone-server-database.sh"
rm "${docker_dir_name}/data/www/import-custom-database.sh"

fi




#
# update the /etc/hosts file
#

echo "making the update-hosts.sh script executable"
chmod +x wordpress-docker-installation-script/includes/update-hosts.sh

wordpress-docker-installation-script/includes/update-hosts.sh $project_dir_name

printf "\nDevilbox Install script complete! \n"
printf "\nnow visit http://${project_dir_name}.loc\n"
