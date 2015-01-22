Command               = require 'domain/Command'
CommandResult         = require 'domain/CommandResult'
UpdateActionStatement = require 'data/statements/UpdateActionStatement'
ActionTextChangedNote = require 'domain/documents/ActionTextChangedNote'

class ChangeActionTextCommand extends Command

  constructor: (@user, @actionId, @text) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateActionStatement(@actionId, {@text})
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      result.messages.changed(action)
      result.addNote(new ActionTextChangedNote(@user, action, previous))
      result.action = action
      callback(null, result)

module.exports = ChangeActionTextCommand
