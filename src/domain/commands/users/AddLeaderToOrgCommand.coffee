Command                 = require 'domain/framework/Command'
AddLeaderToOrgStatement = require 'data/statements/AddLeaderToOrgStatement'

class AddLeaderToOrgCommand extends Command

  constructor: (@requester, @org, @user) ->

  execute: (conn, callback) ->
    statement = new AddLeaderToOrgStatement(@org.id, @user.id)
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = AddLeaderToOrgCommand
