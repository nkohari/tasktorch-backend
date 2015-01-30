Command             = require 'domain/framework/Command'
CommandResult       = require 'domain/framework/CommandResult'
UpdateUserStatement = require 'data/statements/UpdateUserStatement'

class ChangeUserNameCommand extends Command

  constructor: (@user, @name) ->

  execute: (conn, callback) ->
    result    = new CommandResult(@user)
    statement = new UpdateUserStatement(@user.id, {name: @name})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      # TODO: We need support for this, but it's sketchy because there's
      # no organization on User. Revisit.
      #result.messages.changed(user)
      result.user = user
      callback(null, result)

module.exports = ChangeUserNameCommand
