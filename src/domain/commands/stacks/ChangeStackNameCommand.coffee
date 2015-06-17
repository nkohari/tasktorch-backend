Command         = require 'domain/framework/Command'
Stack           = require 'data/documents/Stack'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeStackNameCommand extends Command

  constructor: (@user, @stack, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Stack, @stack.id, {@name})
    conn.execute statement, (err, stack) =>
      return callback(err) if err?
      callback(null, stack)

module.exports = ChangeStackNameCommand
