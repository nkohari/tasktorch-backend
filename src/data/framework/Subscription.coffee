{EventEmitter}   = require 'events'
ChangesStatement = require 'data/statements/ChangesStatement'

class Subscription extends EventEmitter

  constructor: (@connectionPool, @doctype) ->

  start: (callback) ->
    @connectionPool.acquire (err, conn) =>
      return callback(err) if err?
      statement = new ChangesStatement(@doctype)
      conn.execute statement, (err, cursor) =>
        return callback(err) if err?
        cursor.each(@onChange)
        callback()

  onChange: (err, change) =>
    [previous, current] = [change.old_val, change.new_val]
    if previous? and current?
      @emit('update', {
        type:     @doctype.name
        document: new @doctype(current)
        previous: new @doctype(previous)
      })
    else if current? and not previous?
      @emit('create', {
        type:     @doctype.name
        document: new @doctype(current)
      })
    else if previous? and not current?
      @emit('delete', {
        type:     @doctype.name
        document: new @doctype(previous)
      })

module.exports = Subscription
