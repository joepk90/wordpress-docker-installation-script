# $server_ip
# $server_name
# $server_port
# $server_dir_path
# $server_domain

if [ -n  "$1" ]
then
server_ip=$1
else
  exit 1
fi

if [ -n  "$2" ]
then
server_ip=$2
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
server_ip=$4
else
  exit 1
fi

if [ -n  "$5" ]
then
server_ip=$5
else
  exit 1
fi

# export database from server install
# -o "StrictHostKeyChecking no" stops shh checking for authenticity of key fingerprint
echo "export database on server"
ssh -o "StrictHostKeyChecking no" $server_name@$server_ip -p $server_port -t "cd $server_dir_path; wp db export docker-db.sql; exit; bash"

# copy database to docker project directory
echo "copy database from server to local"
rsync -chavzP -e "ssh -p $server_port" $server_name@$server_ip:$server_dir_path/docker-db.sql ./
# rsync -chavzP -e ssh -p $server_port $server_name@$server_ip:$server_dir_path/docker-db.sql ./

# delete exported database on server (clean up)
# -o "StrictHostKeyChecking no" stops shh checking for authenticity of key fingerprint
echo "clean up - delete database on server"
ssh -o "StrictHostKeyChecking no" $server_name@$server_ip -p $server_port -t "cd $server_dir_path; rm docker-db.sql; exit; bash"




