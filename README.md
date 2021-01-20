# Playground On Vault

What is Vault? See my [HackMD file](https://hackmd.io/@Lu-Shueh-Chou/S1olCKrAD)

Some useful demo see [here](https://hackmd.io/idIbJh-aRj-yT7_1Q5AqKQ)

## authenticate

GitHub as example

[detail](authenticate/README.md)

## HA

Build a standby node and step-down the active node.
You will see now the original standby node, now become active.

[detail](HA/README.md)

## pki

Build your TLS certificate by Vault.
This will need `consul-template`, please install first

[detail](pki/README.md)

## token

Do some token stuff

-   List accessor
-   Batch token
-   Wrap token
-   Revoke token by accessor

[detail](token/README.md)

## transit

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
