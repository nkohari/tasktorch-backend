EventEmitter = require 'events'

class Connection extends EventEmitter

  Object.defineProperty @prototype, 'isOpen',    {get: -> @conn.open}
  Object.defineProperty @prototype, 'isClosing', {get: -> @conn.closing}

  constructor: (@id, @log, @conn) ->
    @conn.on 'close',   @onClose
    @conn.on 'timeout', @onTimeout
    @conn.on 'error',   @onError

  execute: (runnable, callback) ->
    runnable.prepare @conn, (err) =>
      return callback(err) if err?
      @log.debug("[db:#{@id}] #{runnable.constructor.name} -> #{runnable.rql.toString()}")
      runnable.run(@conn, callback)

  close: ->
    @conn.removeListener('close',   @onClose)
    @conn.removeListener('timeout', @onTimeout)
    @conn.removeListener('error',   @onError)
    @conn.close()

  onClose: =>
    @emit('close')

  onTimeout: =>
    @emit('timeout')

  onError: (err) =>
    @emit('error', err)

module.exports = Connection
