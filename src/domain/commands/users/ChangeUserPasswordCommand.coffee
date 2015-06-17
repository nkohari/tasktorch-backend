Command         = require 'domain/framework/Command'
User            = require 'data/documents/User'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeUserPasswordCommand extends Command

  constructor: (@user, @password) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(User, @user.id, {password: @password})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = ChangeUserPasswordCommand
