default: run

run:
	docker run --rm -ti                            \
	  -v $${HOME}/.ssh:/var/jenkins_home/.ssh      \
	  -v $$(pwd):/var/jenkins_home                 \
	  -e RUNNING_HOST                              \
	  -e RUNNING_USER=$$(whoami)                   \
	  -e HOST_SCRIPT_DIR=$${HOME}/mesos-systemd/v2 \
	  -u root                                      \
	  -p 8080:8080                                 \
	  jenkins
