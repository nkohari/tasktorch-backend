async               = require 'async'
CreateNoteStatement = require 'data/statements/CreateNoteStatement'

class Processor

  constructor: (@connectionPool, @messageBus) ->

  execute: (command, callback) ->
    @connectionPool.acquire (err, conn) =>
      return callback(err) if err?
      command.execute conn, (err, result) =>
        return callback(err) if err?
        @record conn, result, (err) =>
          return callback(err) if err?
          @messageBus.announce result, (err) =>
            return callback(err) if err?
            @connectionPool.release(conn)
            callback(null, result)

  record: (conn, result, callback) ->
    notes  = result.getNotes()
    create = (data, next) =>
      statement = new CreateNoteStatement(data)
      conn.execute statement, (err, note) =>
        return callback(err) if err?
        result.messages.created(note)
        next()
    async.eachSeries(notes, create, callback)

module.exports = Processor
