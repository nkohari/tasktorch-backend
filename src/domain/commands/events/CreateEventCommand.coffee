Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'

class CreateEventCommand extends Command

  constructor: (@event) ->
    super()

  execute: (conn, callback) ->
    document  = @event.createDocument()
    statement = new CreateStatement(document)
    conn.execute statement, (err, event) =>
      return callback(err) if err?
      callback(null, event)

module.exports = CreateEventCommand
