Command         = require 'domain/framework/Command'
Invite          = require 'data/documents/Invite'
InviteStatus    = require 'data/enums/InviteStatus'
UpdateStatement = require 'data/statements/UpdateStatement'

class AcceptInviteCommand extends Command

  constructor: (@user, @invite) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Invite, @invite.id, {status: InviteStatus.Accepted})
    conn.execute statement, (err, invite) =>
      return callback(err) if err?
      callback(null, invite)

module.exports = AcceptInviteCommand
