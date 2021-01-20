## Token

先重新登入回 `Root Token`

```bash=
# 看看現在是用什麼權杖
$ vault print token
s.AtDndppL6auMYfI27zfkvgn1
# 此權杖並非 Root Token，登出
$ rm ~/.vault-token
$ vault login s.9gFtHEu35b4FCBHbUtaLxeOw
```

### 列出所有 token 的 accessor

```bash=
$ vault list auth/token/accessors
```

### Batch Token

先建立 [Policy](#Policy)

```bash=
$ vault token create -type=batch -orphan=true -policy=my-policy

Key                  Value
---                  -----
token                b.AAAAAQKn0sVCMJNVTBWHXpwjQ1HbgpyDsJ8WeKtVaZiiUCLK13uT4-pknd0lsHyiXVw7jaRy2U03o0K-TjtEU40v5f26KZXiY12vlMakT1WZuL-NdQ6pGD9fj4YGRp39qKY_jbQyrx8
token_accessor       n/a
token_duration       768h
token_renewable      false
token_policies       ["default" "my-policy"]
identity_policies    []
policies             ["default" "my-policy"]
```

batch token 開頭是 `b`，反之，常見的 token 是 `s` 開頭，代表 service token

### Wrapping Token

```bash=
$ vault token create -policy=my-policy -wrap-ttl=120

Key                              Value
---                              -----
wrapping_token:                  s.F7S12zD0PUcEL5VShhElBZIb
wrapping_accessor:               LsfBV3JiC4zwWCaFEZqNW9db
wrapping_token_ttl:              2m
wrapping_token_creation_time:    2021-01-11 16:49:11.614054 +0800 CST
wrapping_token_creation_path:    auth/token/create
wrapped_accessor:                oW7NNQUM35G7mvTQ4vieDPqi
```

```bash=
vault unwrap s.F7S12zD0PUcEL5VShhElBZIb

Key                  Value
---                  -----
token                s.v8lwNg4uwfZzlHvDrmPdkRyF
token_accessor       oW7NNQUM35G7mvTQ4vieDPqi
token_duration       768h
token_renewable      true
token_policies       ["default" "my-policy"]
identity_policies    []
policies             ["default" "my-policy"]
