Command             = require 'domain/framework/Command'
CreateUserStatement = require 'data/statements/CreateUserStatement'

class CreateUserCommand extends Command

  constructor: (@user) ->

  execute: (conn, callback) ->
    statement = new CreateUserStatement(@user)
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = CreateUserCommand
