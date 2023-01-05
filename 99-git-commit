#!/bin/vbash

#        file: 99-git-commit
# description: Saves config commands & config json to files, commits to local
#              git repo. Repo stored in /config/user-data/$CONFIG_REPO. Completes
#              process with a push to the remote repo.
#
#              This script is intended to be used as a post-commit hook, allowing
#              for automated config backup in a git repo.
#
#              Install in /config/scripts/commit/post-hooks.d/ to run automatically
#              after each VyOS commit.
#


# Repository path. You shouldn't need to modify this. This location is persistent
#  across reboots and upgrades in VyOS.
REPO_PATH=/config/user-data

# Set your CONFIG_REPO directory name. This should be an git existing repository.
CONFIG_REPO=config-rtr01

# Timestamp format (YYYY-MM-DDTHH:mm:ss Z)
TIMESTAMP="$(date '+%Y-%m-%dT%H:%M:%S %Z')"

# Below you have two options:
#  OPTION 1 (DEFAULT BEHAVIOR): Set a commit message before committing VyOS changes by  
#  setting the environment variable $M. Otherwise we'll use a generic commit message if 
#  $M is empty.
#
#  OPTION 2: Prompt for a git commit message every time this script is run (i.e., after
#  every VyOS commit). To use OPTION 2, commend out lines 37-41 and uncomment lines
#  44 & 45.
#

# Use generic commit message unless variable "$M" is set (e.g., M="message here" commit;save)
if [ -z "$M" ]; then
  MSG="Auto-triggered by $USER@$HOSTNAME config commit: $TIMESTAMP"
else
  MSG="$M"
fi

# Prompt user for commit message
#echo "Enter git commit message:"
#read MSG

##
## Do the Work
##

# Source the VyOS script-template to allow VyOS config commands to be exported
source /opt/vyatta/etc/functions/script-template

# Save user's current working directory
USERPATH=$PWD

# Change to repo directory & start processing
cd $REPO_PATH/$CONFIG_REPO
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Beginning git commit & push...\e[0m"

# Git: Perform a 'pull' to ensure our local repo is up to date
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Ensuring our local repo is up-to-date...\e[0m"
/usr/bin/git pull

# VyOS: Save config commands & json to files
echo -e "\e[1;32m> [\e[1;37m $TIMESTAMP\e[1;32m ]\e[1;36m Saving configuration files...\e[0m"
run show configuration commands > $REPO_PATH/$CONFIG_REPO/$HOSTNAME.commands.conf
run show configuration > $REPO_PATH/$CONFIG_REPO/$HOSTNAME.config.boot

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

# Change back to user's last $PWD
cd $USERPATH

# Clean up variables
CONFIG_REPO=""
REPO_PATH=""
TIMESTAMP=""
USERPATH=""
MSG=""
M=""
