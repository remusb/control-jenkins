# control-jenkins
Configuration files for jenkins instances that control mesos clusters

# running

```
# aws metadata service hurray
RUNNING_HOST=`curl -s http://169.254.169.254/latest/meta-data/public-hostname` && \
docker run \
  -v /home/core/.ssh:/var/jenkins_home/.ssh       \ # if you want to clone repos
  -v /home/core/control-jenkins:/var/jenkins_home \ # required to mount jobs into home dir
  -e RUNNING_HOST                                 \ # required to control host machine
  -e RUNNING_USER=core                            \ # required to control host machine
  -e FLEET_REPO=git@github.com:my/repo            \ # repository that contains fleet units
  -e FLEET_UNIT_ROOT=v1/fleet_units               \ # subdirectory of FLEET_REPO
  -u root                                         \ # required to fix issues with mounted SSH keys
  -p 8080:8080 \
  jenkins
```
