Command         = require 'domain/framework/Command'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeOrgEmailCommand extends Command

  constructor: (@user, @org, @email) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Org, @org.id, {email: @email})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeOrgEmailCommand
