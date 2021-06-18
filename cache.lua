---
--- Created By 0xWaleed
--- DateTime: 6/18/21 1:25 AM
---

local store = {}

local function is_callable(var)
    if type(var) == 'function' then
        return true
    end

    if type(var) == 'table' and getmetatable(var) and getmetatable(var).__call then
        return true
    end

    return false
end

local function ensure_key(key)
    if type(key) ~= 'string' then
        error('Expected key to be a string.')
    end
end

local function ensure_observer_is_callable(observer)
    if not is_callable(observer) then
        error('Observer is not callable.')
    end
end

function cache_set(key, value)
    ensure_key(key)

    if store[key] then
        store[key].value = value
    else
        store[key] = {
            value = value
        }
    end

    if store[key].setObservers then
        for _, v in ipairs(store[key].setObservers) do
            v(store[key].value)
        end
    end
end

function cache_get(key)
    ensure_key(key)

    local cacheValue = store[key]

    if not cacheValue then
        return nil
    end

    if cacheValue and cacheValue.getObservers then
        for _, v in ipairs(store[key].getObservers) do
            v(cacheValue.value)
        end
    end

    return cacheValue.value
end

function cache_add_set_observer(key, observer)
    ensure_observer_is_callable(observer)

    if not store[key] then
        cache_set(key, nil)
        store[key].setObservers = {}
    end

    table.insert(store[key].setObservers, observer)
end

function cache_add_get_observer(key, observer)
    ensure_observer_is_callable(observer)
    if not store[key] then
        cache_set(key, nil)
        store[key].getObservers = {}
    end
    table.insert(store[key].getObservers, observer)
end
