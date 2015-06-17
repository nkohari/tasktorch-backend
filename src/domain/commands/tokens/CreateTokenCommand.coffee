Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'

class CreateTokenCommand extends Command

  constructor: (@user, @token) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@token)
    conn.execute statement, (err, token) =>
      return callback(err) if err?
      callback(null, token)

module.exports = CreateTokenCommand
