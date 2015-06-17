Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'

class CreateNoteCommand extends Command

  constructor: (@user, @note) ->
    super()

  execute: (conn, callback) ->
    statement = new CreateStatement(@note)
    conn.execute statement, (err, note) =>
      return callback(err) if err?
      callback(null, note)

module.exports = CreateNoteCommand
