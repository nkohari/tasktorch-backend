Command                          = require 'domain/framework/Command'
CreateDefaultUserStacksStatement = require 'data/statements/CreateDefaultUserStacksStatement'
AddMemberToOrgStatement          = require 'data/statements/AddMemberToOrgStatement'

class AddMemberToOrgCommand extends Command

  constructor: (@requester, @user, @org) ->

  execute: (conn, callback) ->
    # TODO: Should check to see if stacks already exist? Not sure what will happen
    # in case where user is removed and re-added.
    statement = new CreateDefaultUserStacksStatement(@user.id, @org.id)
    conn.execute statement, (err) =>
      return callback(err) if err?
      statement = new AddMemberToOrgStatement(@org.id, @user.id)
      conn.execute statement, (err, org) =>
        return callback(err) if err?
        callback(null, org)

module.exports = AddMemberToOrgCommand
