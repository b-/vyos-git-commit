# vyos-git-commit
a commit post-hook for vyos to automatically sync config commits to your (remote) git repository

originally from https://blog.billclark.io/vyos-configuration-backup-automation-with-git

NOTE: You need to use a custom build of VyOS that includes git. I have one with some other additions at https://github.com/b-/vyos-build-action but you really should make your own. How can you trust that I haven't tampered with it? 

NOTE 2: This readme is a very rough first draft I want to make just to get it out of my head. Don't just read and perform the steps. Understand what it is that I'm trying to ask you to do, because I'm probably making a mistake that won't be corrected until a later revision :)

## Installation steps

#NOT FINISHED DO NOT FOLLOW YET

### 1. Create a PRIVATE git repository 
Create a (hosted, private) git repo that is accessible from the router. This repository _WILL_ contain private information such as private keys from the router, so _you really need to make it private._ I'm using a private repo on GitHub.com, but Bill uses a self-hosted repo because that's more trustworthy. 

Since it matches my setup and will be easy for me, let's assume your git repository is hosted at https://github.com/username/vyos-config. 

### 2. Optional: create a branch specific for this router
this will allow you to use one repository for multiple routers. I don't know if this really is ideal or not, but it works. Probably significantly less secure.

### 3. Log into the router, and perform the following: 
```shellsession
vyos@vyos$ 
vyos@vyos$ cd /config/user-data
vyos@vyos$ ssh-keygen -t ed25519 -i ssh_git-deploy
# follow the instructions, OMIT a password so it's not an encrypted key!
vyos@vyos$ git clone 
```



## notes to self

use deploy keys
    which means use system ssh config
        which means you need updated vyos (for /etc/ssh_config.d fix) and possibly custom image (in order to put something there in the first place!)

i should look into what im including with my custom image in order to provide a less hacked one for public (without official support) offering.

look into prebuilding image with deploy keys, but really we should make an xml config commands setup thing (https://github.com/vyos/vyos1x) to add preferred ssh keys for given servers.