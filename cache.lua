---
--- Created By 0xWaleed
--- DateTime: 6/18/21 1:25 AM
---

local store = {}

local function ensure_key(key)
    if type(key) ~= 'string' then
        error('Expected key to be a string.')
    end
end

function cache_set(key, value)
    ensure_key(key)

    store[key] = value
end

function cache_get(key)
    ensure_key(key)

    return store[key]
end

