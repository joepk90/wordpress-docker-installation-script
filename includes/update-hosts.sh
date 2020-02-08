if [ -n  "$1" ]
then
project_dir_name=$1
else
    printf "\nProject directry name invalid! \n"
  exit 1
fi

printf "\nyou will now be prompted for your password,\n"
printf "\nthis is to update your host files with the following: 127.0.0.1 ${project_dir_name}.loc\n"

sudo -- sh -c "echo >> /etc/hosts"
sudo -- sh -c "echo \#\ docker project: ${project_dir_name} >> /etc/hosts"
sudo -- sh -c "echo 127.0.0.1 ${project_dir_name}.loc >> /etc/hosts"

printf "\nnow visit ${project_dir_name}.loc\n"

# printf "Finally exit the docker shell and add the following enry to your host file. run the following commands:\n"
# printf "exit\n"
# printf "sudo vim /etc/hosts\n"
# printf "127.0.0.1 ${project_dir_name}.loc\n"