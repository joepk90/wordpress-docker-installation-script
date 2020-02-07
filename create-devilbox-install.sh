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

read -p 'Do you want to create a default Wordpress installation? (y/n) ' run_default_wp_installer

if [ "$run_default_wp_installer" == "y" ]
then
  echo "Running Wordpress installer. This will create a a new Wordpress database and install Wordpress"

  # go back to the orignal directory where script was running
  cd $current_dir_path

  echo "making the prepare-wordpress-install-script.sh script executable"
  chmod +x wordpress-docker-installation-script/prepare-wordpress-install-script.sh

  wordpress-docker-installation-script/prepare-wordpress-install-script.sh $project_dir_name

else

  read -p 'Do you want to clone an exisiting wordpress repository? (y/n) ' run_clone_repository_script

  if [ "$run_clone_repository_script" == "y" ]
  then

    # go back to the orignal directory where script was running
    cd $current_dir_path

    echo "making the clone-git-repoistory.sh script executable"
    chmod +x wordpress-docker-installation-script/includes/clone-git-repository.sh

    wordpress-docker-installation-script/includes/clone-git-repository.sh $project_dir_name

  fi

  read -p 'Do you want to import a database from Kinsta? (y/n) ' run_kinsta_db_importer

  if [ "$run_kinsta_db_importer" == "y" ]
  then


  echo "making the clone-kinsta-database.sh script executable"
  chmod +x wordpress-docker-installation-script/includes/clone-kinsta-database.sh

  echo "copying clone-kinsta-database.shscript to project directory"
  cp wordpress-docker-installation-script/includes/clone-kinsta-database.sh "${project_dir_name}/data/www/"

  cd ${project_dir_name}

  # run script ithin docker shell
  docker-compose exec --user devilbox php bash -l clone-kinsta-database.sh ${project_dir_name}

  fi

fi

printf "\nDevilbox Install script complete! \n"
printf "\nnow visit ${project_dir_name}.loc\n"
