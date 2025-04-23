#!/bin/bash

LOGF=/container.log

#Define cleanup procedure
cleanup() {
    echo "########################################" >> ${LOGF}
    echo "Container stopped, performing cleanup..." >> ${LOGF}
    # server

    echo "Done -> rotating log..." >> ${LOGF}
    echo "########################################" >> ${LOGF}
    mv ${LOGF} ${LOGF}.1
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

# run odoo
service postgresql start
sleep 5 && sudo -u postgres /init_db.sh

service odoo start

# keep container alive
tail -f /dev/null &

#Wait
wait $!
