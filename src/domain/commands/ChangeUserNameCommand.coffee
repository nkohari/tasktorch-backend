Command             = require 'domain/Command'
CommandResult       = require 'domain/CommandResult'
UpdateUserStatement = require 'data/statements/UpdateUserStatement'

class ChangeUserNameCommand extends Command

  constructor: (@user, @name) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateUserStatement(@user.id, {name: @name})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      result.messages.changed(user)
      result.user = user
      callback(null, result)

module.exports = ChangeUserNameCommand
