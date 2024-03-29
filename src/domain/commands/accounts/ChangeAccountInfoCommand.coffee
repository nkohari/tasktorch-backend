Command         = require 'domain/framework/Command'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeAccountInfoCommand extends Command

  constructor: (@orgid, @info) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Org, @orgid, {account: @info})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeAccountInfoCommand
