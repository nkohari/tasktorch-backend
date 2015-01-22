Command             = require 'domain/Command'
CommandResult       = require 'domain/CommandResult'
CreateNoteStatement = require 'data/statements/CreateNoteStatement'

class CreateNoteCommand extends Command

  constructor: (@user, @note) ->
    super()

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new CreateNoteStatement(@note)
    conn.execute statement, (err, note) =>
      return callback(err) if err?
      result.messages.created(note)
      result.note = note
      console.log "CREATED"
      callback(null, result)

module.exports = CreateNoteCommand
