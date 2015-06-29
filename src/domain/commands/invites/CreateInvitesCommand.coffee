Command             = require 'domain/framework/Command'
BulkCreateStatement = require 'data/statements/BulkCreateStatement'
Invite              = require 'data/documents/Invite'

class CreateInvitesCommand extends Command

  constructor: (@user, @invites) ->

  execute: (conn, callback) ->
    statement = new BulkCreateStatement(Invite, @invites)
    conn.execute statement, (err, invites) =>
      return callback(err) if err?
      callback(null, invites)

module.exports = CreateInvitesCommand
