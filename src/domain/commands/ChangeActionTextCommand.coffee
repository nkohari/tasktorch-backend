Command               = require 'domain/Command'
CommandResult         = require 'domain/CommandResult'
UpdateActionStatement = require 'data/statements/UpdateActionStatement'

class ChangeActionTextCommand extends Command

  constructor: (@user, @actionId, @text) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateActionStatement(@actionId, {@text})
    conn.execute statement, (err, action) =>
      return callback(err) if err?
      result.messages.changed(action)
      result.action = action
      callback(null, result)

module.exports = ChangeActionTextCommand
