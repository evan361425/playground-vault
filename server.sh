#!/bin/bash

# go to root folder
path=$PWD
while [ ! -f "$path/server.sh" -a $path != '.' ]; do
  path=$(dirname $path)
  cd ..
done

# check vault is listening
if [ $(lsof -nP | grep LISTEN | grep -c vault) = 0 ]; then
  echo 'Start building server!'
  vault server -config=config.hcl &
  echo 'Waiting initialization...'
  sleep 3
fi

# 0 => unsealed, 1 error, 2 => sealed
vault status > /dev/null

# if sealed then unsealed it
if [ $? -eq 2 ]; then
  status=$(vault status | grep '^Initialized' | awk '{print $2}')
  if [ $status = 'false' ]; then
    echo 'Start Initialization!'
    result=$(vault operator init -key-shares=1 -key-threshold=1)

    echo "$result" | grep '^Unseal Key' | awk '{print $4}' > .key
    echo "$result" | grep '^Initial Root Token' | awk '{print $4}' > root.token
  fi

  echo 'Unsealing'
  curl -s \
    --request PUT \
    --data "{\"key\":\"$(cat '.key')\"}" \
    "$VAULT_ADDR/v1/sys/unseal" > /dev/null
fi

# if not login try login
name=$(vault token lookup | grep policies | awk '{print $2}')
if [ $name != '[root]' ]; then
  # HA mode change from standby to active
  echo 'Try login...'
  sleep 1

  # if find token then login
  if [ -f 'root.token' ]; then
    vault login $(cat 'root.token')
  else
    echo "Can't find token"
    exit 1;
  fi
fi
