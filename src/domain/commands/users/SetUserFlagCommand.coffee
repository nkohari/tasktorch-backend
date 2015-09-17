Command              = require 'domain/framework/Command'
User                 = require 'data/documents/User'
SetUserFlagStatement = require 'data/statements/SetUserFlagStatement'

class SetUserFlagCommand extends Command

  constructor: (@user, @flag, @value) ->

  execute: (conn, callback) ->
    statement = new SetUserFlagStatement(@user.id, @flag, @value)
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = SetUserFlagCommand
