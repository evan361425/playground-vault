## HA

Different from original config:

```json=
{
  "listener": {
    "tcp": {
      "address": "127.0.0.1:8100",
      "cluster_address": "127.0.0.1:8101"
    }
  }
}
```

```bash=
$ export VAULT_ADDR="http://127.0.0.1:8100"
$ vault status

Key                      Value
---                      -----
Recovery Seal Type       shamir
Initialized              true
Sealed                   false
Total Recovery Shares    1
Threshold                1
Version                  1.6.1
Storage Type             mysql
Cluster Name             vault-cluster-d4a98a31
Cluster ID               06bbee1f-d643-31c1-a87b-ba43d3b1d2d3
HA Enabled               true
HA Cluster               https://127.0.0.1:8201
HA Mode                  standby
Active Node Address      http://127.0.0.1:8200
```
