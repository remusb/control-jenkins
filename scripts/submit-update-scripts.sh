#!/bin/bash
eval ${SETUPKEYS}

# set etcd values for cluster to reference
echo "---- setting scripts version in etcd ----"
eval "${SSHCMD} 'etcdctl set /environment/SCRIPTS-FORK $FORK'"
eval "${SSHCMD} 'etcdctl set /environment/SCRIPTS-SHA $SHA'"

echo "---- updating scripts ----"
eval "${SSHCMD} 'fleetctl destroy update-scripts || :'"
while [ "$(eval "${SSHCMD} 'fleetctl list-units|grep update-scripts'")" != "" ]; do sleep 1; done
eval "${SSHCMD} 'fleetctl submit ${HOST_SCRIPT_DIR}/util-units/update-scripts.service'"
eval "${SSHCMD} 'fleetctl start update-scripts'"
echo "--------> submitted script update request to cluster..."
while [ "$(eval "${SSHCMD} 'fleetctl list-units|grep update-scripts|tr -s [:space:]|cut -s -f3|uniq'")" != "inactive" ]
do
    UNIT_STATUSES=$(eval "${SSHCMD} 'fleetctl list-units|grep update-scripts|tr -s [:space:]|cut -s -f3|uniq'")
    for status in $UNIT_STATUSES; do
        if [ "$status" == "failed" ]; then
            exit 1
        fi
    done
    sleep 1
done
eval "${SSHCMD} 'fleetctl destroy update-scripts || :'"
while [ "$(eval "${SSHCMD} 'fleetctl list-units|grep update-scripts'")" != "" ]; do sleep 1; done
