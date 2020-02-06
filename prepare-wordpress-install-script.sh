if [ -n  "$1" ]
then
project_dir_name=$1
else
  exit 1
fi

read -p 'what do you want to call your new projects database? ' project_db_name

echo "making the wordpress-database-import script executable"
chmod +x wordpress-docker-installation-script/create-wordpress-install.sh

echo "copying wordpress-database-import script to project directory"
cp wordpress-docker-installation-script/create-wordpress-install.sh "${project_dir_name}/data/www/"

cd ${project_dir_name}

# run script ithin docker shell
docker-compose exec --user devilbox php bash -l create-wordpress-install.sh ${project_dir_name} ${project_db_name}

cd ..
rm "${project_dir_name}/data/www/create-wordpress-install.sh"

printf "\n you will now be prompted for your password,\n"
printf "\n this is to update your host files with the following: 127.0.0.1 ${project_dir_name}.loc\n"

sudo -- sh -c "echo >> /etc/hosts"
sudo -- sh -c "echo \#\ docker project: ${project_dir_name} >> /etc/hosts"
sudo -- sh -c "echo 127.0.0.1 ${project_dir_name}.loc >> /etc/hosts"

printf "\nnow visit ${project_dir_name}.loc\n"

# printf "Finally exit the docker shell and add the following enry to your host file. run the following commands:\n"
# printf "exit\n"
# printf "sudo vim /etc/hosts\n"
# printf "127.0.0.1 ${project_dir_name}.loc\n"
