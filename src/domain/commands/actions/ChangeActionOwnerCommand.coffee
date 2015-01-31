Command                = require 'domain/framework/Command'
ActionOwnerChangedNote = require 'data/documents/notes/ActionOwnerChangedNote'
UpdateActionStatement  = require 'data/statements/UpdateActionStatement'
CreateNoteStatement    = require 'data/statements/CreateNoteStatement'

class ChangeActionOwnerCommand extends Command

  constructor: (@user, @action, @owner) ->

  execute: (conn, callback) ->
    if @owner?
      patch = {owner: if @owner? then @owner.id else null}
    else
      patch = {owner: null}
    statement = new UpdateActionStatement(@action.id, patch)
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      note = ActionOwnerChangedNote.create(@user, action, previous)
      statement = new CreateNoteStatement(note)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, action)

module.exports = ChangeActionOwnerCommand
