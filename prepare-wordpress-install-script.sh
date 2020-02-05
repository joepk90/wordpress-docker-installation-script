echo "making the wordpress-database-import script executable"
chmod +x wordpress-docker-installation-script/create-wordpress-install.sh

echo "copying wordpress-database-import script to project directory"
cp wordpress-docker-installation-script/create-wordpress-install.sh "${project_dir_name}/data/www/"

cd ${project_dir_name}

# run script ithin docker shell
docker-compose exec --user devilbox php bash -l create-wordpress-install.sh

cd ..
rm "${project_dir_name}/data/www/create-wordpress-install.sh"

printf "Finally exit the docker shell and add the following enry to your host file. run the following commands:\n"
printf "exit\n"
printf "sudo vim /etc/hosts\n"
printf "127.0.0.1 ${project_dir_name}.loc\n"
