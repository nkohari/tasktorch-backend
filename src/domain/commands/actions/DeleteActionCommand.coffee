Command                       = require 'domain/framework/Command'
ActionDeletedNote             = require 'data/documents/notes/ActionDeletedNote'
DeleteActionStatement         = require 'data/statements/DeleteActionStatement'
RemoveActionFromCardStatement = require 'data/statements/RemoveActionFromCardStatement'
CreateNoteStatement           = require 'data/statements/CreateNoteStatement'

class DeleteActionCommand extends Command

  constructor: (@user, @action) ->

  execute: (conn, callback) ->
    statement = new DeleteActionStatement(@action.id)
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      statement = new RemoveActionFromCardStatement(@action.id)
      conn.execute statement, (err, card) =>
        return callback(err) if err?
        note = ActionDeletedNote.create(@user, action)
        statement = new CreateNoteStatement(note)
        conn.execute statement, (err) =>
          return callback(err) if err?
          callback(null, action)

module.exports = DeleteActionCommand
