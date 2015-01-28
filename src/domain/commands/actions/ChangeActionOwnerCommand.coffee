Command                = require 'domain/Command'
CommandResult          = require 'domain/CommandResult'
UpdateActionStatement  = require 'data/statements/UpdateActionStatement'
ActionOwnerChangedNote = require 'domain/documents/notes/ActionOwnerChangedNote'

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
      result.addNote(new ActionOwnerChangedNote(@user, action, previous))
      result.action = action
      callback(null, result)

module.exports = ChangeActionOwnerCommand
