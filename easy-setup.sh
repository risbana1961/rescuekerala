OS_BASE=$"(uname)"
BUILD_MAC=$"Darwin"
BUILD_LIN=$"Linux"
BUILD_WIN="Windows"
KERALARESCUE_REPO_LINK="https://github.com/IEEEKeralaSection/rescuekerala.git"
# Commands for Apple Mac
if [ $OS_BASE == $BUILD_MAC ] 
then
# Install Git and the repo for Kerala Rescue
brew install git
# ======= Uncomment the following line if you do not have the repository downloaded
# git clone $KERALARESCUE_REPO_LINK
echo "Repository is downloaded now you are ready to go"
cd rescuekerala/
# Install python and pip in mac
brew install python
# Install requirements.txt
pip3 install -r requirements.txt
pip3 install -r requirements_debug.txt
# Implementing docker.sh
chmod 777 docker.sh
sh docker.sh
# PostgreSQL : Expecting that brew is preinstalled in your mac
brew install postgres
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
alias pg_start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg_stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
pg_start
# Use pg_stop to stop the postgres server.
createdb `whoami`
brew reinstall readline
createuser -s postgres
createdb rescuekerala
psql -f postgres_setup.sql rescuekerala
# Copy the environment config to the remote repo  
# -- Additional configuration maybe required
cp .env.example .env
# Database migration for Django and run the server
python3 manage.py migrate
python3 manage.py collectstatic
python3 manage.py runserver
else
# Commands for Linux[Ubuntu]
if [ $OS_BASE == $BUILD_LIN ]
then
# linux commands (for ubuntu)
# Install Git and the repo
sudo apt-get install git
# git clone $KERALARESCUE_REPO_LINK
echo "Repository is downloaded now you are ready to go"
cd rescuekerala/
# Install Python and pip
sudo apt-get intall python3
sudo apt-get install python3-pip
# Install requirements.txt
pip3 install -r requirements.txt
pip3 install -r requirements_debug.txt
# Implementing docker.sh
chmod 777 docker.sh
sh docker.sh
# Postgres setup and installation
# sudo apt-get install wget ca-certificates
# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
sudo apt install postgresql-common
sudo sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
sudo -i -u postgres
createuser -s postgres
createdb rescuekerala
psql -f postgres_setup.sql rescuekerala
# Copy the environment config to the remote repo  
# -- Additional configuration maybe required
cp .env.example .env
# Database migration for Django and run the server
python3 manage.py migrate
python3 manage.py collectstatic
python3 manage.py runserver
fi
fi