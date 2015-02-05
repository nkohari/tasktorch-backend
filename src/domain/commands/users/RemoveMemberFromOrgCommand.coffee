Command                      = require 'domain/framework/Command'
RemoveMemberFromOrgStatement = require 'data/statements/RemoveMemberFromOrgStatement'

class AddMemberToOrgCommand extends Command

  constructor: (@requester, @org, @user) ->

  execute: (conn, callback) ->
    statement = new RemoveMemberFromOrgStatement(@org.id, @user.id)
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = AddMemberToOrgCommand
