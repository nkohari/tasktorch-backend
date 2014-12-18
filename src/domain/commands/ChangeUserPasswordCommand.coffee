Command             = require 'domain/Command'
CommandResult       = require 'domain/CommandResult'
UpdateUserStatement = require 'data/statements/UpdateUserStatement'

class ChangeUserPasswordCommand extends Command

  constructor: (@userId, @password) ->

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new UpdateUserStatement(@userId, {password: @password})
    statement.execute conn, (err, user) =>
      return callback(err) if err?
      result.user = user
      callback(null, result)

module.exports = ChangeUserPasswordCommand
