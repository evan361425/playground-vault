#!/bin/bash

vault auth enable approle
vault write auth/approle/role/example \
    secret_id_ttl=1h \
    token_ttl=3m
