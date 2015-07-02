Command                 = require 'domain/framework/Command'
AddLeaderToOrgStatement = require 'data/statements/AddLeaderToOrgStatement'

class AddMemberToOrgCommand extends Command

  constructor: (@requester, @user, @org) ->

  execute: (conn, callback) ->
    statement = new AddLeaderToOrgStatement(@org.id, @user.id)
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = AddMemberToOrgCommand
