#!/bin/vbash

# vbash is not a typo :)
#
#        file: 99-git-commit
# description: Saves config commands & config json to files, commits to local
#              git repo. $CONF_DIR. Completes process with a push to the remote repo.
#                
#
#              This script is intended to be used as a post-commit hook, allowing
#              for automated config backup in a git repo.
#              
#              Place this file in /config/scripts/commit/post-hooks.d and mark it executable,
#              and this script will run after every commit.
#
#


# Variables: Set your CONF_DIR below, make sure it's an existing it repo
#  i.e., clone the existing repo to a folder in /config/user-data so it's persistent.
TIMESTAMP="$(date '+%Y-%m-%dT%H:%M:%S %Z')"
CONF_DIR=/config/user-data/repository-name

# Set generic commit message unless variable "$M" is set
# (i.e., M="message here" commit;save)
if [ -z "$M" ]; then
  MSG="Auto-triggered by $USER@$HOSTNAME config commit: $TIMESTAMP"
else
  MSG="$M"
fi

# Prompt user for commit message
#echo "Enter git commit message:"
#read MSG

# Source the VyOS script-template to allow VyOS config commands to be exported
source /opt/vyatta/etc/functions/script-template

# Change to repo directory & start processing
cd $CONF_DIR
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Beginning git commit & push...\e[0m"

# Git: Perform a 'pull' to ensure our local repo is up to date
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Making sure our local repo is up-to-date...\e[0m"
/usr/bin/git pull

# VyOS: Save config commands & json to files
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Exporting configuration files...\e[0m"
run show configuration commands > $CONF_DIR/$HOSTNAME.commands.conf
run show configuration > $CONF_DIR/$HOSTNAME.config.boot

# Git: Stage changes
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Staging changes...\e[0m"
/usr/bin/git add -A

# Git: Commit changes
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Committing changes...\e[0m"
/usr/bin/git commit -m "$MSG"

# Git: Push changes to remote
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Pushing changes to remote repository...\e[0m"
/usr/bin/git push

# Process complete
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Git commit & push completed.\e[0m"

# Clean up variables
TIMESTAMP=""
MSG=""
CONF_DIR=""
