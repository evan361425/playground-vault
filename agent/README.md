總共做三件事情：

1.  幫 client 自動登入
2.  暫存必要的東西加速進程
3.  透過 Template 去要指定的東西，並存成檔案

# Auto-Auth

兩部份：

1.  用什麼方法登入？
2.  把得到的權杖用安全的方式存去哪邊？

## 用什麼方法登入

以 AppRole 為範例：

給 Agent

1.  Role ID 的資料位置
2.  Secret ID 的資料位置

他就完成登入動作。

當登入後，預設會自動把設定的 Secret ID 刪除。


## 把得到的權杖用安全的方式存去哪邊

目前僅能存進 `file`
安全的方法：
1. 加密
    - Diffie-Hellman exchange
    - derive key
    - additional authenticated data (AAD)
2. 包裝
    - 把權杖包裝起來再去換

# Caching

僅會暫存：

-   透過 Agent 建立的`權杖`
-   Orphan 權杖
-   透過 Agent 管理的`權杖`獲得的`租賃`

## 預設權杖

透過初始化參數 `use_auto_auth_token` 來設定預設權杖

-   若打進 Agent 的請求帶有`權杖`的標頭，則該`權杖`會被使用而非預設權杖
-   初始化時也可要求無論如何都要使用預設權杖

## 清除暫存

-   TTL 到達
-   透過 Agent 撤銷`權杖`，則會一起清除暫存
-   若在 Agent 之外撤銷，則可以透過 [`/agent/v1/cache-clear`](https://www.vaultproject.io/docs/agent/caching#cache-clear) 手動清除暫存

## 暫存的 Index 是什麼？

HTTP 的標頭和內容做雜湊..
未來應該會改較聰明的作法

## 若 Agent 關掉了怎麼辦

Agent 僅會用 in-memory 的方式作儲存，也就是當 Agent 關掉了，相關的`權杖`、`租賃`會被清除掉，但不會被撤銷。

---

# Template

如果要把輸出結果，加上一些指定的文字印在檔案上，可以用這個功能。

例如：PKI 的 `certificate` 和 `private-key`

## 參數

細節在[此](https://www.vaultproject.io/docs/agent/template#configuration)，以下列出需要注意的項目

-   `command`：若輸出結果改變，可以要求執行指定命令
-   `error_on_missing_key`：雖然預設為 `false`，但強烈建議設成 `true`，否則當沒收到想要的值時，預設會給出空白。可能造成程式上意想不到的錯誤。

## 什麼時候更新 Template 的值

1.  如果是可以更新的 secret 或`權杖`
    -   過期前 1/3 的時候去重新要一次
2.  如果不能更新的 secret 或`權杖`，但是他有`租賃`
    -   `租賃`在大約 85% 的存活期間會被重要一次
3.  如果不能更新的 secret 或`權杖`，而且他沒有`租賃`
    -   每 5 分鐘去要一次，此值是固定的
4.  若值有轉換週期（例如，資料庫的 [static role](https://www.vaultproject.io/docs/secrets/databases#static-roles)）
    -   根據 TTL 去要
5.  若值是憑證（certificate）
    -   根據 `validTo` 去要
    -   若憑證有設定`租賃`，則根據規則 2 去要

---

[HackMD](https://hackmd.io/@Lu-Shueh-Chou/ryAnPIrkO)
