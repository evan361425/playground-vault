#!/bin/bash

# go to root folder
path=$PWD
while [ ! -f "$path/server.sh" -a $path != '.' ]; do
  path=$(dirname $path)
  cd ..
done

# check vault is listening
if [ $(lsof -nP | grep LISTEN | grep -c vault) = 0 ]; then
  echo 'Building Server!'
  vault server -config=config.hcl &
  sleep 2
fi

# 0 => unsealed, 1 error, 2 => sealed
vault status > /dev/null

# if sealed then unsealed it
if [ $? -eq 2 ]; then
  status=$(vault status | grep '^Initialized' | awk '{print $1}')
  if [ $status = 'false' ]; then
    echo 'Start Initialization'
    result=$(vault operator init -key-shares=1 -key-threshold=1)

    unseal_key=$($result | grep '^Unseal' | awk '{print $4}')
    token=$($result | grep '^Initial' | awk '{print $4}')
    echo $token > 'root.token'
    echo $unseal_key > '.key'
  fi

  echo 'Unsealing'
  vault write sys/unseal key=$(cat '.key')
fi

# if find token then login
if [ -f 'root.token' ]; then
  vault login $(cat 'root.token')
else
  echo "Can't find token"
  exit 1;
fi
