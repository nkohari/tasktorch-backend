Command               = require 'domain/framework/Command'
CommandResult         = require 'domain/framework/CommandResult'
ActionTextChangedNote = require 'data/documents/notes/ActionTextChangedNote'
UpdateActionStatement = require 'data/statements/UpdateActionStatement'

class ChangeActionTextCommand extends Command

  constructor: (@user, @action, @text) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateActionStatement(@action.id, {@text})
    conn.execute statement, (err, action, previous) =>
      return callback(err) if err?
      result.messages.changed(action)
      result.addNote(ActionTextChangedNote.create(@user, action, previous))
      result.action = action
      callback(null, result)

module.exports = ChangeActionTextCommand
