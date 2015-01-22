Command                 = require 'domain/Command'
CommandResult           = require 'domain/CommandResult'
UpdateActionStatement   = require 'data/statements/UpdateActionStatement'
ActionStatusChangedNote = require 'domain/documents/ActionStatusChangedNote'

class ChangeActionStatusCommand extends Command

  constructor: (@user, @actionId, @status) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateActionStatement(@actionId, {@status})
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      result.messages.changed(action)
      result.addNote(new ActionStatusChangedNote(@user, action, previous))
      result.action = action
      callback(null, result)

module.exports = ChangeActionStatusCommand
