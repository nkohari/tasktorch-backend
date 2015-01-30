Command              = require 'domain/framework/Command'
CommandResult        = require 'domain/framework/CommandResult'
DeleteStackStatement = require 'data/statements/DeleteStackStatement'

class DeleteStackCommand extends Command

  constructor: (@user, @stack) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new DeleteStackStatement(@stack.id)
    conn.execute statement, (err, stack, previous) =>
      return callback(err) if err?
      result.messages.deleted(stack)
      result.stack = stack
      callback(null, result)

module.exports = DeleteStackCommand
