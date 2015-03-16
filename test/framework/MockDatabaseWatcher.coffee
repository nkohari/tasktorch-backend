{EventEmitter} = require 'events'

class MockDatabaseWatcher extends EventEmitter

  start: (callback = (->)) ->
    callback()

module.exports = MockDatabaseWatcher
