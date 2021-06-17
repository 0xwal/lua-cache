---
--- Created By 0xWaleed
--- DateTime: 6/17/21 11:12 PM
---

function hard_require(module)
    require(module)
    package.loaded[module] = nil
end

describe('cache', function()
    before_each(function()
        hard_require('cache')
    end)

    it('should throw when key is not a string for set', function()
        local wrapper = function(input)
            return function()
                cache_set(input)
            end
        end

        assert.was.error(wrapper(true), 'Expected key to be a string.')
        assert.was.error(wrapper(1), 'Expected key to be a string.')
        assert.was.error(wrapper({}), 'Expected key to be a string.')
        assert.was.error(wrapper(function() end), 'Expected key to be a string.')
    end)

    it('should throw when key is not a string for get', function()
        local wrapper = function(input)
            return function()
                cache_get(input)
            end
        end

        assert.was.error(wrapper(true), 'Expected key to be a string.')
        assert.was.error(wrapper(1), 'Expected key to be a string.')
        assert.was.error(wrapper({}), 'Expected key to be a string.')
        assert.was.error(wrapper(function() end), 'Expected key to be a string.')
    end)

    it('should able to add value to a key', function()
        cache_set('players', 1)
        assert.is_equals(1, cache_get('players'))
    end)


end)
