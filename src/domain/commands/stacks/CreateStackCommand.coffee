Command              = require 'domain/Command'
CommandResult        = require 'domain/CommandResult'
CreateStackStatement = require 'data/statements/CreateStackStatement'

class CreateStackCommand extends Command

  constructor: (@user, @stack) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new CreateStackStatement(@stack)
    conn.execute statement, (err, stack) =>
      return callback(err) if err?
      result.messages.created(stack)
      result.stack = stack
      callback(null, result)

module.exports = CreateStackCommand
