Command         = require 'domain/framework/Command'
DeleteStatement = require 'data/statements/DeleteStatement'

class DeleteStackCommand extends Command

  constructor: (@user, @stack) ->

  execute: (conn, callback) ->
    statement = new DeleteStatement(@stack)
    conn.execute statement, (err, stack, previous) =>
      return callback(err) if err?
      callback(null, stack)

module.exports = DeleteStackCommand
