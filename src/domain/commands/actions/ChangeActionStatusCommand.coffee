Command                 = require 'domain/framework/Command'
CommandResult           = require 'domain/framework/CommandResult'
ActionStatusChangedNote = require 'data/documents/notes/ActionStatusChangedNote'
UpdateActionStatement   = require 'data/statements/UpdateActionStatement'

class ChangeActionStatusCommand extends Command

  constructor: (@user, @action, @status) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateActionStatement(@action.id, {@status})
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      result.messages.changed(action)
      result.addNote(ActionStatusChangedNote.create(@user, action, previous))
      result.action = action
      callback(null, result)

module.exports = ChangeActionStatusCommand
