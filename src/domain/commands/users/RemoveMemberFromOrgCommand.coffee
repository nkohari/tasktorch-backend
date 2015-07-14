Command                                = require 'domain/framework/Command'
RemoveMemberFromOrgStatement           = require 'data/statements/RemoveMemberFromOrgStatement'
RemoveMemberFromAllTeamsInOrgStatement = require 'data/statements/RemoveMemberFromAllTeamsInOrgStatement'

class AddMemberToOrgCommand extends Command

  constructor: (@requester, @org, @user) ->

  execute: (conn, callback) ->
    statement = new RemoveMemberFromOrgStatement(@org.id, @user.id)
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      statement = new RemoveMemberFromAllTeamsInOrgStatement(@org.id, @user.id)
      conn.execute statement, (err) =>
        return callback(err) if err?
        callback(null, org)

module.exports = AddMemberToOrgCommand
