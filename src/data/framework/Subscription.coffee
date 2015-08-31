EventEmitter     = require 'events'
arrayEnum        = require 'common/util/arrayEnum'
ChangesStatement = require 'data/statements/ChangesStatement'

State = arrayEnum [
  'Stopped'
  'Starting'
  'Started'
]

class Subscription extends EventEmitter

  constructor: (@log, @connectionPool, @doctype) ->
    @state = State.Stopped

  start: (callback) ->
    return callback() unless @state is State.Stopped
    @setState(State.Starting)
    @connectionPool.acquire (err, conn) =>
      return callback(err) if err?
      @connection = conn
      @connection.on('close',   @onClosed)
      @connection.on('timeout', @onTimeout)
      @connection.on('error',   @onError)
      statement   = new ChangesStatement(@doctype)
      @connection.execute statement, (err, cursor) =>
        return callback(err) if err?
        @setState(State.Started)
        cursor.each(@onChange)
        callback()

  restart: (callback = (->)) ->
    @connection.removeListener('close',   @onClosed)
    @connection.removeListener('timeout', @onTimeout)
    @connection.removeListener('error',   @onError)
    @connectionPool.release(@connection)
    @setState(State.Stopped)
    @start(callback)

  onChange: (err, change) =>

    return @restart() if err?
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

    return

  onClosed: =>
    @log.debug "Subscription for #{@doctype.name}: Connection closed"
    @restart()

  onTimeout: =>
    @log.debug "Subscription for #{@doctype.name}: Connection timed out"
    @restart()

  onError: =>
    @log.debug "Subscription for #{@doctype.name}: Connection error: #{err}"
    @restart()

  setState: (state) ->
    @log.debug("Subscription for #{@doctype.name}: #{@state} -> #{state}")
    @state = state

module.exports = Subscription
