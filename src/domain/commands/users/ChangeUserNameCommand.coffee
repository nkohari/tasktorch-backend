Command         = require 'domain/framework/Command'
User            = require 'data/documents/User'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeUserNameCommand extends Command

  constructor: (@user, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(User, @user.id, {name: @name})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = ChangeUserNameCommand
