# Playground On Vault

What is Vault? See my [HackMD file](https://hackmd.io/@Lu-Shueh-Chou/S1olCKrAD)

Some useful demo see [here](https://hackmd.io/idIbJh-aRj-yT7_1Q5AqKQ)

Agent? see [here](https://hackmd.io/@Lu-Shueh-Chou/ryAnPIrkO)

## Authenticate

GitHub as example

[detail](authenticate/README.md)

## High Availability

Build a standby node and step-down the active node.

You will see the original standby node become active.

[detail](HA/README.md)

## PKI

Build your TLS certificate by Vault.

This will need `consul-template`, please install first.

[detail](pki/README.md)

## Token

Do some token stuff

-   List accessor
-   Batch token
-   Wrap token
-   Revoke token by accessor

[detail](token/README.md)

## Transit

Encryption as server

-   Encryption
-   Decryption
-   Key rotate
-   Disable old key to encrypt / decrypt
-   Rewrap cipher
-   Remove old key

[detail](transit/README.md)

# License

See in [LICENSE file](LICENSE)
