# vyos-git-commit
a commit post-hook for vyos to automatically sync config commits to your (remote) git repository

originally from https://blog.billclark.io/vyos-configuration-backup-automation-with-git

NOTE: You need to use a custom build of VyOS that includes git. I have one with some other additions at https://github.com/b-/vyos-build-action but you really should make your own. How can you trust that I haven't tampered with it? 

NOTE 2: This readme is a very rough first draft I want to make just to get it out of my head. Don't just read and perform the steps. Understand what it is that I'm trying to ask you to do, because I'm probably making a mistake that won't be corrected until a later revision :)

## Installation steps

1. Create a PRIVATE git repository that is accessible from the router. This repository _WILL_ contain private information such as private keys from the router, so _you really need to make it private._ For the rest of this readme, let's assume your git repository is hosted at https://github.com/username/vyos-config
2. Optional: create a branch specific for this router — this will allow you to use one repository for multiple routers. I don't know if this really is a good idea or not, but it works.
3. Log into the router, and perform the following: 
```shellsession
vyos@vyos$ 
vyos@vyos$ cd /config/user-data
vyos@vyos$ 
```
