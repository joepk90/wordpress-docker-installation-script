# SHELL SCRIPT
# will be run from withon the docker shell
# starting directory: project/data/www/

if [ -n  "$1" ]
then
project_dir_name=$1
else
  exit 1
fi

# debugging
# printf "\nentered the shell \n"
# printf "\nmoving too ${project_dir_name}/htdocs/ \n"

cd ${project_dir_name}/htdocs/

# debugging
# printf "\ngetting wordpress \n"

wget https://wordpress.org/latest.tar.gz -q --show-progress
tar -xzf latest.tar.gz # include v for verbose (-xzvf)
mv wordpress/* ./
rmdir wordpress/
rm latest.tar.gz

exit 1