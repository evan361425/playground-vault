# Authentication

-   [GitHub](#github)
-   [AppRole](#approle)

---

## GitHub

先允許 GitHub 登入

```bash=
$ vault auth enable github
$ vault write auth/github/config organization=104corp
```

### 登出

```bash=
$ rm ~/.vault-token
```

### Access Token

#### 存取權杖

去 [GitHub 設定頁](https://github.com/settings/profile) > Developer settings > Personal access tokens > Generate new token

權限要有：`admin:org > read:org`，讓 Vault 可以讀取你帳號的組織

### 登入

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

### 資訊

```bash=
$ vault token lookup s.AtDndppL6auMYfI27zfkvgn1
```

---

## AppRole

AppRole 是指建立好指定的 `role-id` 後

要求 secret-id 的 TTL，就可以產生動態的安全登入機制

### 先建立環境

```bash=
$ vault auth enable approle
$ vault write auth/approle/role/example \
    secret_id_ttl=1h \
    token_ttl=3m
```

### 輸出帳號密碼

```bash=
$ vault read -field=role_id \
  auth/approle/role/example/role-id \
  > approle-role.id
$ vault write -f -field=secret_id \
  auth/approle/role/example/secret-id \
  > approle-secret.id
```

### 登出

```bash=
$ rm ~/.vault-token
```

### 登入

```bash=
$ vault write -field=token \
  auth/approle/login \
  role_id=$(cat 'approle-role.id') \
  secret_id=$(cat 'approle-secret.id') \
  > approle.token
```

### 資訊

```bash=
$ vault login $(cat approle.token)
$ vault print token
```
