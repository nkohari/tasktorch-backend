Command              = require 'domain/framework/Command'
CommandResult        = require 'domain/framework/CommandResult'
UpdateStackStatement = require 'data/statements/UpdateStackStatement'

class ChangeStackNameCommand extends Command

  constructor: (@user, @stack, @name) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateStackStatement(@stack.id, {@name})
    conn.execute statement, (err, stack) =>
      return callback(err) if err?
      result.messages.changed(stack)
      result.stack = stack
      callback(null, result)

module.exports = ChangeStackNameCommand
