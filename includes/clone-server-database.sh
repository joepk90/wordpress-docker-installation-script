# current_dir_path
# project_dir_name

# $server_ip
# $user_name
# $server_port
# $server_dir_path
# $server_domain

if [ -n  "$1" ]
then
current_dir_path=$1
else
  printf "\ncno current directory path provided\n"
  exit 1
fi

if [ -n  "$2" ]
then
docker_dir_name=$2
else
  printf "\ncno current directory path provided\n"
  exit 1
fi

if [ -n  "$3" ]
then
project_dir_name=$3
else
  printf "\ncno project directory path provided\n"
  exit 1
fi

if [ -n  "$4" ]
then
server_ip=$4
else
  printf "\ncno server ip provided\n"
  exit 1
fi

if [ -n  "$5" ]
then
user_name=$5
else
  printf "\ncno user name provided\n"
  exit 1
fi

if [ -n  "$6" ]
then
printf "\ncno server port provided\n"
server_port=$6
else
  exit 1
fi

if [ -n  "$7" ]
then
server_dir_path=$7
else
  printf "\ncno server directory path provided\n"
  exit 1
fi

if [ -n  "$8" ]
then
server_domain=$8
else
  printf "\ncno server domain path provided\n"
  exit 1
fi

cd $current_dir_path/$docker_dir_name/data/www/$project_dir_name/htdocs

# export database from server install
# -o "StrictHostKeyChecking no" stops shh checking for authenticity of key fingerprint
printf "\nexport database on server \n"
ssh -o "StrictHostKeyChecking no" $user_name@$server_ip -p $server_port -t "cd $server_dir_path; wp db export docker-db.sql; exit; bash"

# copy database to docker project directory

printf "\ncopy database from server to local \n"
rsync -chavzP -e "ssh -p $server_port" $user_name@$server_ip:$server_dir_path/docker-db.sql ./
# rsync -chavzP -e ssh -p $server_port $user_name@$server_ip:$server_dir_path/docker-db.sql ./

# delete exported database on server (clean up)
# -o "StrictHostKeyChecking no" stops shh checking for authenticity of key fingerprint
printf "\nclean up - delete database on server \n"
ssh -o "StrictHostKeyChecking no" $user_name@$server_ip -p $server_port -t "cd $server_dir_path; rm docker-db.sql; exit; bash"

exit 1


