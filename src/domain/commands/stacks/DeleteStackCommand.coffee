Command              = require 'domain/framework/Command'
DeleteStackStatement = require 'data/statements/DeleteStackStatement'

class DeleteStackCommand extends Command

  constructor: (@user, @stack) ->

  execute: (conn, callback) ->
    statement = new DeleteStackStatement(@stack.id)
    conn.execute statement, (err, stack, previous) =>
      return callback(err) if err?
      callback(null, stack)

module.exports = DeleteStackCommand
