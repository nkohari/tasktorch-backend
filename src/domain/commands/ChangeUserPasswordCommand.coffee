Command             = require 'domain/Command'
CommandResult       = require 'domain/CommandResult'
UpdateUserStatement = require 'data/statements/UpdateUserStatement'

class ChangeUserPasswordCommand extends Command

  constructor: (@user, @password) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateUserStatement(@user.id, {password: @password})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      result.user = user
      callback(null, result)

module.exports = ChangeUserPasswordCommand
