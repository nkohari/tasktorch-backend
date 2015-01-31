Command              = require 'domain/framework/Command'
CreateStackStatement = require 'data/statements/CreateStackStatement'

class CreateStackCommand extends Command

  constructor: (@user, @stack) ->

  execute: (conn, callback) ->
    statement = new CreateStackStatement(@stack)
    conn.execute statement, (err, stack) =>
      return callback(err) if err?
      callback(null, stack)

module.exports = CreateStackCommand
