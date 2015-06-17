Command         = require 'domain/framework/Command'
User            = require 'data/documents/User'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeUserEmailCommand extends Command

  constructor: (@user, @email) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(User, @user.id, {email: @email})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = ChangeUserEmailCommand
