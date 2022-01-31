---
--- Created By 0xWaleed <https://github.com/0xWaleed>
--- DateTime: 29/12/2021 9:18 AM
---

---@alias SetFunc fun(key: string, value: string)
---@alias GetFunc fun(key: string)
---@alias UnsetFunc fun(key: string)


---@class CacheDriver
---@field name string
---@field set SetFunc
---@field get GetFunc
---@field unset UnsetFunc
---@field export function|nil
---@field import function|nil


---@alias CacheDriverInitFunc fun(): CacheDriver
