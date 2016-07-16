#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

if [[ "$@" == "apache2-foreground" ]]; then
  exec "/usr/local/bin/apache2-foreground"
  exit
fi

USER_ID=${LOCAL_USER_ID:-9001}

echo "Current User : $(whoami)"
echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

exec /usr/local/bin/gosu user "$@"
