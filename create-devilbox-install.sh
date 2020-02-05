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

read -p 'Do you want to create a default Wordpress installation? (y/n) ' run_default_wp_installer

if [ "$run_default_wp_installer" == "y" ]
then
  echo "Running Wordpress installer. This will create a a new Wordpress database and install Wordpress"

  # go back to the orignal directory where script was running
  cd ../../../../../

  echo "making the wordpress-database-import script executable"
  chmod +x wordpress-docker-installation-script/create-wordpress-install.sh

  echo "copying wordpress-database-import script to project directory"
  cp wordpress-docker-installation-script/create-wordpress-install.sh "${project_dir_name}/data/www/$project_dir_name/htdocs/"


  printf "now run the following commands:\n"
  printf "cd ${project_dir_name}\n"
  printf "./shell.sh\n"
  printf "cd ${project_dir_name}/htdocs\n"
  printf "./create-wordpress-install.sh\n"
  printf "Finally exit the docker shell and add the following enry to your host file. run the following commands:\n"
  printf "exit\n"
  printf "sudo vim /etc/hosts\n"
  printf "127.0.0.1 ${project_dir_name}.loc\n"

  # ./create-wordpress-install.sh

else

  read -p 'Do you want to import a database from Kinsta? (y/n) ' run_kinsta_db_importer

  if [ "$run_kinsta_db_importer" == "y" ]
  then

  printf "get kinsta DB copy script from the wordpress-docker-install.sh script"

  fi

fi

echo "Devilbox Install script complete"
