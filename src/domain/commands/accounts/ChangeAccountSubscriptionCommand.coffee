Command                = require 'domain/framework/Command'
Org                    = require 'data/documents/Org'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class ChangeAccountSubscriptionCommand extends Command

  constructor: (@accountid, @subscription) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Org, {account: @accountid}, {account: {@subscription}})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeAccountSubscriptionCommand
