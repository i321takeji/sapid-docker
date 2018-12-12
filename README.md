# Docker images for Sapid #

 * Sapid http://www.sapid.org/

## Tags
 * `debian-6.104.4`
 * `ubuntu-6.104.4`
 * `alpine-6.104.4`
 
 ## Usage
```bash
$ ls
main.c
$ docker pull bamboog130/sapid-docker:ubuntu-6.104.4
$ docker run --rm -it -v `pwd`:/sapid-work bamboog130/sapid-docker:ubuntu-6.104.4
# pwd
/sapid-work
# sdb4 main.c
# ls
SDB  main.c
```
