Command                = require 'domain/framework/Command'
CommandResult          = require 'domain/framework/CommandResult'
ActionOwnerChangedNote = require 'data/documents/notes/ActionOwnerChangedNote'
UpdateActionStatement  = require 'data/statements/UpdateActionStatement'

class ChangeActionOwnerCommand extends Command

  constructor: (@user, @action, @owner) ->

  execute: (conn, callback) ->
    result = new CommandResult(@user)
    if @owner?
      patch = {owner: if @owner? then @owner.id else null}
    else
      patch = {owner: null}
    statement = new UpdateActionStatement(@action.id, patch)
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      result.messages.changed(action)
      result.addNote(ActionOwnerChangedNote.create(@user, action, previous))
      result.action = action
      callback(null, result)

module.exports = ChangeActionOwnerCommand
