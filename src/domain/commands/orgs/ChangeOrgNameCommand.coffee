Command         = require 'domain/framework/Command'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeOrgNameCommand extends Command

  constructor: (@user, @org, @name) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Org, @org.id, {name: @name})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeOrgNameCommand
