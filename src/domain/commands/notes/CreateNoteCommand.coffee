Command             = require 'domain/framework/Command'
CreateNoteStatement = require 'data/statements/CreateNoteStatement'

class CreateNoteCommand extends Command

  constructor: (@user, @note) ->
    super()

  execute: (conn, callback) ->
    statement = new CreateNoteStatement(@note)
    conn.execute statement, (err, note) =>
      return callback(err) if err?
      callback(null, note)

module.exports = CreateNoteCommand
