class Processor

  constructor: (@connectionPool, @messageBus) ->

  execute: (command, callback) ->
    @connectionPool.acquire (err, conn) =>
      return callback(err) if err?
      command.execute conn, (err, result) =>
        return callback(err) if err?
        @messageBus.announce result, (err) =>
          return callback(err) if err?
          @connectionPool.release(conn)
          callback(null, result)

module.exports = Processor
