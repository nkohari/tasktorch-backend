Command         = require 'domain/framework/Command'
Org             = require 'data/documents/Org'
UpdateStatement = require 'data/statements/UpdateStatement'

class ChangeAccountCancellationReasonCommand extends Command

  constructor: (@orgid, @reason) ->

  execute: (conn, callback) ->
    statement = new UpdateStatement(Org, @orgid, {account: {cancelReason: @reason}})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeAccountCancellationReasonCommand
