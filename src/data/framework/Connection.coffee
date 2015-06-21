class Connection

  Object.defineProperty @prototype, 'isOpen',    {get: -> @conn.open}
  Object.defineProperty @prototype, 'isClosing', {get: -> @conn.closing}

  constructor: (@id, @log, @conn) ->

  execute: (runnable, callback) ->
    runnable.prepare @conn, (err) =>
      return callback(err) if err?
      @log.debug("[db:#{@id}] #{runnable.constructor.name} -> #{runnable.rql.toString()}")
      runnable.run(@conn, callback)

  close: ->
    @conn.close()

module.exports = Connection
