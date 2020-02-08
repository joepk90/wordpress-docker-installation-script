# current_dir_path
# project_dir_name

# $server_ip
# $server_name
# $server_port
# $server_dir_path
# $server_domain

if [ -n  "$1" ]
then
current_dir_path=$1
else
  exit 1
fi

if [ -n  "$2" ]
then
project_dir_name=$2
else
  exit 1
fi

if [ -n  "$3" ]
then
server_ip=$3
else
  exit 1
fi

if [ -n  "$4" ]
then
server_name=$4
else
  exit 1
fi

if [ -n  "$5" ]
then
server_port=$5
else
  exit 1
fi

if [ -n  "$6" ]
then
server_dir_path=$6
else
  exit 1
fi

if [ -n  "$7" ]
then
server_domain=$7
else
  exit 1
fi

cd $current_dir_path/$project_dir_name/data/www/$project_dir_name/htdocs

# export database from server install
# -o "StrictHostKeyChecking no" stops shh checking for authenticity of key fingerprint
printf "\nexport database on server \n"
ssh -o "StrictHostKeyChecking no" $server_name@$server_ip -p $server_port -t "cd $server_dir_path; wp db export docker-db.sql; exit; bash"

# copy database to docker project directory

printf "\ncopy database from server to local \n"
rsync -chavzP -e "ssh -p $server_port" $server_name@$server_ip:$server_dir_path/docker-db.sql ./
# rsync -chavzP -e ssh -p $server_port $server_name@$server_ip:$server_dir_path/docker-db.sql ./

# delete exported database on server (clean up)
# -o "StrictHostKeyChecking no" stops shh checking for authenticity of key fingerprint
printf "\nclean up - delete database on server \n"
ssh -o "StrictHostKeyChecking no" $server_name@$server_ip -p $server_port -t "cd $server_dir_path; rm docker-db.sql; exit; bash"

exit 1


