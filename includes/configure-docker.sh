if [ -n  "$1" ]
then
docker_dir_name=$1
else
  exit 1
fi

if [ -n  "$2" ]
then
project_dir_name=$2
else
  exit 1
fi

read -p 'Do you want to create a new docker instance? (y/n) ' install_docker

if [ "$install_docker" == "y" ]
then

user_id=$(id -u)
user_group=$(id -g)

if [ -n "$user_id" ]
then
printf "\nYour User ID is ${user_id}\n"
else
read -p 'what is your user id (run id -u to find out)? ' user_id
fi

if [ -n "$user_group" ]
then
printf "\nYour User Group is ${user_group}\n"
else
read -p 'what is your user id (run id -g to find out)? ' user_group
fi

git clone https://github.com/cytopia/devilbox $docker_dir_name
# mkdir $project_dir_name // testing


cd $docker_dir_name
cp env-example .env

# replace NEW_UID in .env file (using variables not yet tested)
sed -i '' "s/NEW_UID=1000/NEW_UID=${user_id}/g" .env

# replace NEW_GID in .env file (using variables not yet tested)
sed -i '' "s/NEW_GID=1000/NEW_GID=${user_group}/g" .env

# start devil box running (maybe turn this into a flag? -- start)
docker-compose up -d

# this could be done in one command...
mkdir -p data/www/$project_dir_name/htdocs
# cd data/www/$project_dir_name/htdocs

fi