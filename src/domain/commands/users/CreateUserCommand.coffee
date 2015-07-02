Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'

class CreateUserCommand extends Command

  constructor: (@user) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@user)
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = CreateUserCommand
