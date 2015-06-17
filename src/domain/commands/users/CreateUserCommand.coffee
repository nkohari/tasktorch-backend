Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'
DeleteStatement = require 'data/statements/DeleteStatement'

class CreateUserCommand extends Command

  constructor: (@user, @token) ->

  execute: (conn, callback) ->
    # Exchange the token for a user record.
    # TODO: If the token has an org associated with it, add the user to the org as well.
    statement = new DeleteStatement(@token)
    conn.execute statement, (err, token) =>
      return callback(err) if err?
      statement = new CreateStatement(@user)
      conn.execute statement, (err, user) =>
        return callback(err) if err?
        callback(null, user)

module.exports = CreateUserCommand
