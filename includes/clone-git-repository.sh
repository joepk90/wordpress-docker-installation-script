if [ -n  "$1" ]
then
project_dir_name=$1
else
    printf "\nProject directry name invalid! \n"
  exit 1
fi

read -p 'what is the URL of the repository you want to clone? ' project_repo_name

# this could be done in one command...
mkdir -p data/www/$project_dir_name/htdocs
# cd data/www/$project_dir_name/htdocs

# get project files from bitbucket repository
# -C flag is for specifying a path
git -C data/www/$project_dir_name/htdocs clone $project_repo_name repository-files

# another flag or command might be required here to mv hidden files
# note: .[^.]* means all hidden files except . and ..
mv data/www/$project_dir_name/htdocs/repository-files/{,.[^.]}* data/www/$project_dir_name/htdocs/
rm -rf data/www/$project_dir_name/htdocs/repository-files/



# testing command
# mkdir -p test-project/repo-directory/
# git -C test-project/repo-directory/ clone git@bitbucket.org:supadu/wordpress-docker-installation-script.git repository-files
# mv test-project/repo-directory/repository-files/{,.[^.]}* test-project/repo-directory/
# rm -rf test-project/

