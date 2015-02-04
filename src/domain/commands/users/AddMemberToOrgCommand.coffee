Command                          = require 'domain/framework/Command'
CreateDefaultUserStacksStatement = require 'data/statements/CreateDefaultUserStacksStatement'
AddMemberToOrgStatement          = require 'data/statements/AddMemberToOrgStatement'

class AddMemberToOrgCommand extends Command

  constructor: (@requester, @user, @org) ->

  execute: (conn, callback) ->
    statement = new CreateDefaultUserStacksStatement(@user.id, @org.id)
    conn.execute statement, (err) =>
      return callback(err) if err?
      statement = new AddMemberToOrgStatement(@org.id, @user.id)
      conn.execute statement, (err, org) =>
        return callback(err) if err?
        callback(null, org)

module.exports = AddMemberToOrgCommand
