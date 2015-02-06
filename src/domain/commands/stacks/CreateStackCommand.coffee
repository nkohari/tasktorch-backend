Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'

class CreateStackCommand extends Command

  constructor: (@user, @stack) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@stack)
    conn.execute statement, (err, stack) =>
      return callback(err) if err?
      callback(null, stack)

module.exports = CreateStackCommand
