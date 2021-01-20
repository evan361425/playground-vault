[HackMD](https://hackmd.io/@Lu-Shueh-Chou/rkDDHaRAv)

# 傳統流程

1.  建立 Certificate Signing Request (CSR)
    -   自己產生公私鑰
    -   用私鑰簽署 CSR
2.  寄發 CSR 給 Certificate Authority (CA)
3.  CA 簽署該 CSR
    -   回傳的東西就是你的 Certificate
4.  若撤銷 CSR 則會更新該 CA 本地端的 Certificate Revocation List (CRL)
    -   或者是 Online Certificate Status Protocal (OCSP)

# 有 Vault 的流程

## 若 root CA 放在 Vault 外面

1.  建立 root CA 在 Vault 外面
2.  建立 intermediate CA 在 Vault 裡面
3.  建立 intermediate CA 的 CSR
4.  拿出 CSR 並簽署然後放進 Vault 裡面

## 若 root CA 在 Vault 裡面

順著上述流程打 API 就好

# 撤銷 短期的 TTL 可以省掉撤銷的機制，並且縮短 CRL 的長度
-   不建議利用 command 撤銷，多利用短期的 TTL 和自動化去達到安全性
