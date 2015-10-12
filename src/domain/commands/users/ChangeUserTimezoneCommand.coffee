Command         = require 'domain/framework/Command'
User            = require 'data/documents/User'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeUserTimezoneCommand extends Command

  constructor: (@user, @timezone) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(User, @user.id, {@timezone})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = ChangeUserTimezoneCommand
