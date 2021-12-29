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

    it('should return nil not available key', function()
        assert.is_equals(nil, cache_get('players'))
    end)

    it('should able to add set observer to a key', function()
        local observer = spy()
        cache_add_set_observer('players', observer)
        cache_set('players', 66)
        assert.spy(observer).was_called(1)
        assert.spy(observer).was_called_with(66)
    end)

    it('should able to add set observer for already exist key', function()
        local observer = spy()
        cache_set('players', 66)
        cache_add_set_observer('players', observer)
        cache_set('players', 11)
        assert.spy(observer).was_called(1)
        assert.spy(observer).was_called_with(11)
    end)

    it('should able to add get observer to a key', function()
        local observer = spy()
        cache_add_get_observer('players', observer)
        cache_set('players', 66)
        cache_get('players')
        assert.spy(observer).was_called(1)
        assert.spy(observer).was_called_with(66)
    end)

    it('should able to add set observer for already exist key', function()
        local observer = spy()
        cache_set('players', 11)
        cache_get('players')
        cache_add_get_observer('players', observer)
        cache_get('players')
        assert.spy(observer).was_called(1)
        assert.spy(observer).was_called_with(11)
    end)

    it('should able to add multi set observers for a key', function()
        local observer1 = spy()
        local observer2 = spy()
        cache_add_set_observer('players', observer1)
        cache_add_set_observer('players', observer2)
        cache_set('players', 66)
        assert.spy(observer1).was_called(1)
        assert.spy(observer1).was_called_with(66)
        assert.spy(observer2).was_called(1)
        assert.spy(observer2).was_called_with(66)
    end)

    it('should able to add multi get observers for a key', function()
        local observer1 = spy()
        local observer2 = spy()
        cache_add_get_observer('players', observer1)
        cache_add_get_observer('players', observer2)
        cache_set('players', 66)
        cache_get('players')
        assert.spy(observer1).was_called(1)
        assert.spy(observer1).was_called_with(66)
        assert.spy(observer2).was_called(1)
        assert.spy(observer2).was_called_with(66)
    end)

    it('should throw when set observer is not a callable', function()
        local wrapper = function(observer)
            return function()
                cache_add_set_observer('key', observer)
            end
        end

        assert.was.error(wrapper(0), 'Observer is not callable.')
        assert.was.error(wrapper(true), 'Observer is not callable.')
        assert.was.error(wrapper({}), 'Observer is not callable.')
        assert.was.error(wrapper("string"), 'Observer is not callable.')
    end)

    it('should throw when get observer is not a callable', function()
        local wrapper = function(observer)
            return function()
                cache_add_get_observer('key', observer)
            end
        end

        assert.was.error(wrapper(0), 'Observer is not callable.')
        assert.was.error(wrapper(true), 'Observer is not callable.')
        assert.was.error(wrapper({}), 'Observer is not callable.')
        assert.was.error(wrapper("string"), 'Observer is not callable.')
    end)

    it('should throw when add set observer with key that is not a string', function()
        local wrapper = function(key)
            return function()
                cache_add_set_observer(key, spy())
            end
        end

        assert.was.error(wrapper(0), 'Expected key to be a string.')
        assert.was.error(wrapper(true), 'Expected key to be a string.')
        assert.was.error(wrapper({}), 'Expected key to be a string.')
        assert.was.error(wrapper(nil), 'Expected key to be a string.')
    end)

    it('should throw when we add get observer with key that is not a string', function()
        local wrapper = function(key)
            return function()
                cache_add_get_observer(key, spy())
            end
        end

        assert.was.error(wrapper(0), 'Expected key to be a string.')
        assert.was.error(wrapper(true), 'Expected key to be a string.')
        assert.was.error(wrapper({}), 'Expected key to be a string.')
        assert.was.error(wrapper(nil), 'Expected key to be a string.')
    end)

    it('should able to remove set observer', function()
        local observer = spy()
        cache_add_set_observer('players', observer)
        cache_remove_set_observer('players', observer)
        cache_set('players', 66)
        assert.spy(observer).was_not_called()
    end)

    it('should throw when trying to remove a set observer with key that is not a string', function()
        local wrapper = function(key)
            return function()
                cache_remove_set_observer(key, spy())
            end
        end
        assert.was.error(wrapper(0), 'Expected key to be a string.')
        assert.was.error(wrapper(true), 'Expected key to be a string.')
        assert.was.error(wrapper({}), 'Expected key to be a string.')
        assert.was.error(wrapper(nil), 'Expected key to be a string.')
    end)

    it('should not throw when trying to remove a set observer with not existent key', function()
        assert.was_no_error(function()
            cache_remove_set_observer('players', spy())
        end)
    end)

    it('should not throw when trying to remove a set observer with existent key that has no observer', function()
        assert.was_no_error(function()
            cache_set('players', 1)
            cache_remove_set_observer('players', spy())
        end)
    end)

    it('should able to remove get observer', function()
        local observer = spy()
        cache_add_get_observer('players', observer)
        cache_remove_get_observer('players', observer)
        cache_get('players')
        assert.spy(observer).was_not_called()
    end)

    it('should throw when trying to remove a get observer with key that is not a string', function()
        local wrapper = function(key)
            return function()
                cache_remove_get_observer(key, spy())
            end
        end
        assert.was.error(wrapper(0), 'Expected key to be a string.')
        assert.was.error(wrapper(true), 'Expected key to be a string.')
        assert.was.error(wrapper({}), 'Expected key to be a string.')
        assert.was.error(wrapper(nil), 'Expected key to be a string.')
    end)

    it('should not throw when trying to remove a get observer with not existent key', function()
        assert.was_no_error(function()
            cache_remove_get_observer('players', spy())
        end)
    end)

    it('should not throw when trying to remove a get observer with existent key that has no observer', function()
        assert.was_no_error(function()
            cache_set('players', 1)
            cache_remove_get_observer('players', spy())
        end)
    end)

    it('should able to remove item from cache', function()
        cache_set('key', 1)
        cache_unset('key')
        assert.is_nil(cache_get('key'))
    end)

    it('should remove observers if we remove item', function()
        local setObserverSpy = spy()
        local getObserverSpy = spy()
        cache_set('key', 1)
        cache_add_set_observer('key', setObserverSpy)
        cache_add_get_observer('key', getObserverSpy)
        cache_get('key')
        cache_set('key', 2)
        cache_unset('key')
        cache_set('key', 3)
        cache_get('key')
        assert.spy(setObserverSpy).was_called(1)
        assert.spy(getObserverSpy).was_called(1)
    end)

    it('should not remove other items', function()
        cache_set('key1', 1)
        cache_set('key2', 1)
        cache_unset('key1')
        assert.is_equal(1, cache_get('key2'))
    end)

    it('should not throw when removing item that not exist', function()
        assert.was_no_error(function()
            cache_unset('not-exist-key')
        end)
    end)
end)

describe('cache driver', function()

    before_each(function()
        hard_require('cache')
    end)

    it('should able to set with custom driver', function()
        local driverSet = spy()
        cache_set_driver(function()
            return {
                set = driverSet,
                get = spy()
            }
        end)

        cache_set('k', 'v')

        assert.spy(driverSet).was_called()
        assert.spy(driverSet).was_called_with('k', 'v')
    end)

    it('should able to get with custom driver', function()
        local driverGet = spy()
        cache_set_driver(function()
            return {
                get = driverGet,
                set = spy()
            }
        end)

        cache_get('k')

        assert.spy(driverGet).was_called()
        assert.spy(driverGet).was_called_with('k')
    end)

    it('should able to unset with custom driver', function()
        local driverUnset = spy()
        cache_set_driver(function()
            return {
                unset = driverUnset,
                set   = spy(),
                set   = spy()
            }
        end)

        cache_unset('k')

        assert.spy(driverUnset).was_called()
        assert.spy(driverUnset).was_called_with('k')
    end)
end)

describe('cache api', function()
    before_each(function()
        hard_require('cache')
    end)

    describe('remember', function()
        it('should invoke the callback once and get value everytime', function()
            local getter = stub().returns('hello')
            local value  = cache_remember('k', getter)
            assert.spy(getter).was_called(1)
            assert.is_equal('hello', value)
        end)

    end)
end)
