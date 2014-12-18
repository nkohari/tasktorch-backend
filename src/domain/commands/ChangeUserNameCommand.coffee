Command             = require 'domain/Command'
CommandResult       = require 'domain/CommandResult'
UpdateUserStatement = require 'data/statements/UpdateUserStatement'

class ChangeUserNameCommand extends Command

  constructor: (@userId, @name) ->

  execute: (conn, callback) ->
    result = new CommandResult()
    statement = new UpdateUserStatement(@userId, {name: @name})
    statement.execute conn, (err, user) =>
      return callback(err) if err?
      result.user = user
      result.changed(user)
      callback(null, result)

module.exports = ChangeUserNameCommand
