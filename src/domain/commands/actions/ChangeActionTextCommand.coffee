Command               = require 'domain/framework/Command'
ActionTextChangedNote = require 'data/documents/notes/ActionTextChangedNote'
UpdateActionStatement = require 'data/statements/UpdateActionStatement'
CreateNoteStatement   = require 'data/statements/CreateNoteStatement'

class ChangeActionTextCommand extends Command

  constructor: (@user, @action, @text) ->

  execute: (conn, callback) ->
    statement = new UpdateActionStatement(@action.id, {@text})
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      note = ActionTextChangedNote.create(@user, action, previous)
      statement = new CreateNoteStatement(note)
      statement.execute note, (err) =>
        return callback(err) if err?
        callback(null, action)

module.exports = ChangeActionTextCommand
