Command         = require 'domain/framework/Command'
CreateStatement = require 'data/statements/CreateStatement'

class CreateInviteCommand extends Command

  constructor: (@user, @invite) ->

  execute: (conn, callback) ->
    statement = new CreateStatement(@invite)
    conn.execute statement, (err, invite) =>
      return callback(err) if err?
      callback(null, invite)

module.exports = CreateInviteCommand
