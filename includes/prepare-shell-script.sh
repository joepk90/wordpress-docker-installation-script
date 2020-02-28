if [ -n  "$1" ]
then
docker_dir_name=$1
else
  exit 1
fi

if [ -n  "$2" ]
then
shell_script=$2
else
  exit 1
fi
  
printf "\nmaking the ${shell_script} script executable\n" 
chmod +x wordpress-docker-installation-script/includes/${shell_script}

printf "\ncopying ${shell_script} script to project directory\n"
cp wordpress-docker-installation-script/includes/${shell_script} "${docker_dir_name}/data/www/"