Command                 = require 'domain/framework/Command'
ActionStatusChangedNote = require 'data/documents/notes/ActionStatusChangedNote'
UpdateActionStatement   = require 'data/statements/UpdateActionStatement'
CreateNoteStatement     = require 'data/statements/CreateNoteStatement'

class ChangeActionStatusCommand extends Command

  constructor: (@user, @action, @status) ->

  execute: (conn, callback) ->
    statement = new UpdateActionStatement(@action.id, {@status})
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      note = ActionStatusChangedNote.create(@user, action, previous)
      statement = new CreateNoteStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, action)

module.exports = ChangeActionStatusCommand
