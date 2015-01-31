Command             = require 'domain/framework/Command'
UpdateUserStatement = require 'data/statements/UpdateUserStatement'

class ChangeUserPasswordCommand extends Command

  constructor: (@user, @password) ->

  execute: (conn, callback) ->
    statement = new UpdateUserStatement(@user.id, {password: @password})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = ChangeUserPasswordCommand
