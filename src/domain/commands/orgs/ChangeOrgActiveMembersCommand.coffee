Command         = require 'domain/framework/Command'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeOrgActiveMembersCommand extends Command

  constructor: (@orgid, @activeMembers) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Org, @orgid, {@activeMembers})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeOrgActiveMembersCommand
