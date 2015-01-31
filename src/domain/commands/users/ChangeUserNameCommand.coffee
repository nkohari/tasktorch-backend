Command             = require 'domain/framework/Command'
UpdateUserStatement = require 'data/statements/UpdateUserStatement'

class ChangeUserNameCommand extends Command

  constructor: (@user, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateUserStatement(@user.id, {name: @name})
    conn.execute statement, (err, user) =>
      return callback(err) if err?
      callback(null, user)

module.exports = ChangeUserNameCommand
