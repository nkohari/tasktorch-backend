Command                          = require 'domain/framework/Command'
Invite                           = require 'data/documents/Invite'
InviteStatus                     = require 'data/enums/InviteStatus'
CreateDefaultUserStacksStatement = require 'data/statements/CreateDefaultUserStacksStatement'
AddLeaderToOrgStatement          = require 'data/statements/AddLeaderToOrgStatement'
AddMemberToOrgStatement          = require 'data/statements/AddMemberToOrgStatement'
UpdateStatement                  = require 'data/statements/UpdateStatement'

class AcceptInviteCommand extends Command

  constructor: (@requester, @user, @invite) ->

  execute: (conn, callback) ->
    
    statement = new CreateDefaultUserStacksStatement(@user.id, @invite.org)
    conn.execute statement, (err) =>
      return callback(err) if err?

      if @invite.leader
        statement = new AddLeaderToOrgStatement(@invite.org, @user.id)
      else
        statement = new AddMemberToOrgStatement(@invite.org, @user.id)

      conn.execute statement, (err, org) =>
        return callback(err) if err?
        statement = new UpdateStatement(Invite, @invite.id, {status: InviteStatus.Accepted})
        conn.execute statement, (err, invite) =>
          return callback(err) if err?
          callback(null, invite)

module.exports = AcceptInviteCommand
