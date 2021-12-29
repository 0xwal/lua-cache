---
--- Created By 0xWaleed
--- DateTime: 6/18/21 1:25 AM
---

local g_setObservers = {}
local g_getObservers = {}

function memoryDriver()
    local store = {}
    local m     = {}

    m.name      = 'memory'

    m.get       = function(key)
        return store[key]
    end

    m.set       = function(key, value)
        store[key] = value
    end

    m.unset     = function(key)
        store[key] = nil
    end

    return m
end

---@type CacheDriver
local g_cacheDriver = memoryDriver()

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

    g_cacheDriver.set(key, value)

    if g_setObservers[key] then
        for _, v in pairs(g_setObservers[key]) do
            v(value)
        end
    end
end

function cache_unset(key)
    g_cacheDriver.unset(key)
    g_setObservers[key] = nil
    g_getObservers[key] = nil
end

function cache_get(key)
    ensure_key(key)

    local cacheValue = g_cacheDriver.get(key)

    if not cacheValue then
        return nil
    end

    if g_getObservers[key] then
        for _, v in pairs(g_getObservers[key]) do
            v(cacheValue)
        end
    end

    return cacheValue
end

function cache_add_set_observer(key, observer)
    ensure_observer_is_callable(observer)
    ensure_key(key)

    if not g_setObservers[key] then
        g_setObservers[key] = {}
    end

    g_setObservers[key][tostring(observer)] = observer
end

function cache_remove_set_observer(key, observer)
    ensure_key(key)

    if not g_setObservers[key] then
        return
    end

    g_setObservers[key][tostring(observer)] = nil
end

function cache_add_get_observer(key, observer)
    ensure_observer_is_callable(observer)
    ensure_key(key)

    if not g_getObservers[key] then
        g_getObservers[key] = {}
    end

    g_getObservers[key][tostring(observer)] = observer
end

function cache_remove_get_observer(key, observer)
    ensure_key(key)

    if not g_getObservers[key] then
        return
    end

    g_getObservers[key][tostring(observer)] = nil
end

---@param driverInitFunc CacheDriverInitFunc
function cache_set_driver(driverInitFunc)
    g_cacheDriver = driverInitFunc()
end

function cache_remember(key, getter)
    local value = cache_get(key)

    if value then
        return value
    end

    value = getter()

    cache_set(key, value)

    return value
end
