Command              = require 'domain/framework/Command'
UpdateStackStatement = require 'data/statements/UpdateStackStatement'

class ChangeStackNameCommand extends Command

  constructor: (@user, @stack, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateStackStatement(@stack.id, {@name})
    conn.execute statement, (err, stack) =>
      return callback(err) if err?
      callback(null, stack)

module.exports = ChangeStackNameCommand
