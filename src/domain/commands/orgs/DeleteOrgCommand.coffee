Command         = require 'domain/framework/Command'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'

class DeleteOrgCommand extends Command

  constructor: (@user, @org) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Org, @org.id, {status: OrgStatus.Deleted})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = DeleteOrgCommand
