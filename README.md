# vyos-git-commit
a commit post-hook for vyos to automatically sync config commits to your (remote) git repository

originally from https://blog.billclark.io/vyos-configuration-backup-automation-with-git

NOTE: You need to use a custom build of VyOS that includes git. I have one with some other additions at https://github.com/b-/vyos-build-action but you really should make your own. How can you trust that I haven't tampered with it? 

NOTE 2: This readme is a very rough first draft I want to make just to get it out of my head. Don't just read and perform the steps. Understand what it is that I'm trying to ask you to do, because I'm probably making a mistake that won't be corrected until a later revision :)

## Installation steps

### 1. Create a PRIVATE git repository 
Create a (hosted, private) git repo that is accessible from the router. This repository _WILL_ contain private information such as WireGuard private keys from the router, so _you really need to make it private._ I'm using a private repo on GitHub.com, but Bill uses a self-hosted repo because that's more trustworthy. 

Since it matches my setup and will be easy for me, let's assume your git repository is hosted at https://github.com/username/vyos-config. 

### 2. Optional: create a branch specific for this router
this will allow you to use one repository for multiple routers. I don't know if this really is ideal or not, but it works. Probably significantly less secure.

### 3. Log into the router, and create a new private key in `/config/user-data`: 
```shellsession
vyos@vyos$ 
vyos@vyos$ cd /config/user-data
vyos@vyos$ ssh-keygen -t ed25519 -f ssh_git_deploy
# follow the instructions, OMIT a password so it's not an encrypted key!
vyos@vyos$ cat ssh_git_deploy.pub 
```

### 4. Upload that private key to your git host as a Deploy Key with write access
![image](https://user-images.githubusercontent.com/284789/231319135-a3f4cbd2-fcd6-477b-bbd8-d191747335eb.png)



### 5. Clone your git repository using the new private key into `/config/user-data/vyos-config`
```shellsession
# We're going to preset the user.name and user.email `git config` values. don't be concerned...
vyos@vyos$ git clone -c "core.sshCommand=ssh -F/dev/null -i/config/user-data/ssh_git-deploy" -c "user.email=vyos@vyos" -c "user.name=vyos router" git@github.com:briorg/vyos-config -b vyos.home.ibeep.com --single-branch /config/user-data/vyos-config
vyos@vyos$ 
Cloning into 'vyos-config'...
remote: Enumerating objects: 1650, done.
remote: Counting objects: 100% (29/29), done.
remote: Compressing objects: 100% (19/19), done.
remote: Total 1650 (delta 14), reused 23 (delta 10), pack-reused 1621
Receiving objects: 100% (1650/1650), 186.06 KiB | 5.32 MiB/s, done.
Resolving deltas: 100% (1094/1094), done.
```

### 6. Clone _this_ repository
```shellsession
vyos@vyos:/config/user-data$ git clone https://github.com/b-/vyos-git-commit /config/user-data/vyos-git-commit
Cloning into 'vyos-git-commit'...
remote: Enumerating objects: 42, done.
remote: Counting objects: 100% (42/42), done.
remote: Compressing objects: 100% (23/23), done.
remote: Total 42 (delta 10), reused 37 (delta 8), pack-reused 0
Receiving objects: 100% (42/42), 7.14 KiB | 3.57 MiB/s, done.
Resolving deltas: 100% (10/10), done.
```

### 7. symlink the script into place
```shellsession
vyos@vyos# mkdir /config/scripts/commit/post-hooks.d -p
vyos@vyos# ln -s /config/user-data/vyos-git-commit/99-git-commit /config/scripts/commit/post-hooks.d/
```

That's it! 

You can test it by changing the config, and making a commit:
```shellsession
vyos@vyos$ configure
[edit]
vyos@vyos# set firewall group network-group foo
[edit]
vyos@vyos# commit
vyos@vyos-evo# commit
> [ 2023-04-12T00:43:02 UTC ] Beginning git commit & push...
> [ 2023-04-12T00:43:02 UTC ] Ensuring our local repo is up-to-date...
Already up to date.
> [ 2023-04-12T00:43:02 UTC ] Saving configuration files...
> [ 2023-04-12T00:43:02 UTC ] Staging changes...
> [ 2023-04-12T00:43:02 UTC ] Committing changes...
[vyos-evo a8a4eb6] Auto-triggered by vyos@vyos-evo config commit: 2023-04-12T00:43:02 UTC
 2 files changed, 3 deletions(-)
> [ 2023-04-12T00:43:02 UTC ] Pushing changes to remote repository...
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 2 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 427 bytes | 427.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:briorg/vyos-config
   e17d766..a8a4eb6  vyos-evo -> vyos-evo
> [ 2023-04-12T00:43:02 UTC ] Git commit & push completed.
```
