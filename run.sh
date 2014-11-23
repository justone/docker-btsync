#!/bin/bash

BTSYNC_UID=1000
BTSYNC_GID=1000

BTSYNC_USER=btsync
BTSYNC_HOME=/btsync

if [[ ! -e $BTSYNC_HOME ]]; then
    echo "No $BTSYNC_HOME bind mount detected, creating throwaway directory."
    mkdir $BTSYNC_HOME
else
    echo "Bind mount $BTSYNC_HOME found."
    BTSYNC_UID=$(ls -nd $BTSYNC_HOME | awk '{ print $3 }')
    BTSYNC_GID=$(ls -nd $BTSYNC_HOME | awk '{ print $4 }')
fi

echo "Setting up user ($BTSYNC_USER) to run btsync."
addgroup --gid $BTSYNC_GID $BTSYNC_USER &> /dev/null
adduser --uid $BTSYNC_UID --gid $BTSYNC_GID $BTSYNC_USER --home $BTSYNC_HOME --no-create-home --disabled-password --gecos '' &> /dev/null

chown ${BTSYNC_USER}.${BTSYNC_USER} $BTSYNC_HOME

if [[ ! -e $BTSYNC_HOME/.sync ]]; then
  mkdir $BTSYNC_HOME/.sync
  chown ${BTSYNC_USER}.${BTSYNC_USER} $BTSYNC_HOME/.sync
fi

if [[ ! -e $BTSYNC_HOME/btsync.conf ]]; then
  cat > $BTSYNC_USER/btsync.conf <<EOF
{ 
  "device_name": "Docker BTsync",
  "listening_port" : 55555,
  "storage_path" : "/btsync/.sync",
  "check_for_updates" : true, 
  "use_upnp" : true,
  "download_limit" : 0,                       
  "upload_limit" : 0, 
  "webui" :
  {
    "listen" : "0.0.0.0:8888",
    "login" : "admin",
    "password" : "password"
  }
}
EOF
  chown ${BTSYNC_USER}.${BTSYNC_USER} $BTSYNC_HOME/btsync.conf
fi

cd $BTSYNC_HOME
/usr/bin/gosu $BTSYNC_UID:$BTSYNC_GID /usr/bin/btsync --nodaemon --config $BTSYNC_HOME/btsync.conf
