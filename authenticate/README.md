## Authentication

先允許 GitHub 登入

```bash=
$ vault auth enable github
$ vault write auth/github/config organization=104corp
```

### 登出

```bash=
$ rm ~/.vault-token
```

### GitHub

#### 存取權杖

去 [GitHub 設定頁](https://github.com/settings/profile) > Developer settings > Personal access tokens > Generate new token

權限要有：`admin:org > read:org`，讓 Vault 可以讀取你帳號的組織

#### 登入

```bash=
$ vault login -method=github -token=access-token-from-github

Key                  Value
---                  ------
token                s.AtDndppL6auMYfI27zfkvgn1
token_accessor       WC8tFkMglS9S3RLtitHdAtRe
token_duration       768h
token_renewable      true
token_policies       ["default"]
identity_policies    []
policies             ["default"]
token_meta_username  evan361425
token_meta_org       104corp
```

#### 資訊

```bash=
$ vault token lookup s.AtDndppL6auMYfI27zfkvgn1
```
