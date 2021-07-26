#!/bin/bash

# go to root folder
path=$PWD
while [ ! -f "$path/server.sh" -a $path != '.' ]; do
  echo "$path is not in root of project, try going back"
  path=$(dirname $path)
  cd ..
done

# check vault is listening
if [ $(lsof -nP | grep LISTEN | grep -c vault) = 0 ]; then
  echo 'Start building server!'
  vault server -config=config.hcl &
  echo 'Waiting initialized...'
  sleep 3
fi

# 0 => unsealed, 1 error, 2 => sealed
vault status > /dev/null

# if sealed then unsealed it
if [ $? -eq 2 ]; then
  status=$(vault status | grep '^Initialized' | awk '{print $2}')
  if [ $status = 'false' ]; then
    echo 'Start Initialized!'
    result=$(vault operator init -key-shares=1 -key-threshold=1 -recovery-shares=1 -recovery-threshold=1)

    # there was only one will be shown
    echo "$result" | grep '^Unseal Key' | awk '{print $4}' > .key
    echo "$result" | grep '^Recovery Key' | awk '{print $4}' > .key

    echo "$result" | grep '^Initial Root Token' | awk '{print $4}' > root.token
  fi

  echo 'Unsealing...'
  curl -s \
    --request PUT \
    --data "{\"key\":\"$(cat '.key')\"}" \
    "$VAULT_ADDR/v1/sys/unseal" > /dev/null

  sleep 3;
fi

# if not login try login
name=$(vault token lookup &> >(grep display_name | awk '{print $2}'))
if [ "$name" != "root" ] && [ "$IGNORE_LOGIN" != "true" ]; then
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

echo "Started Vault server!"
