Command                = require 'domain/framework/Command'
Org                    = require 'data/documents/Org'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class ChangeBillingSubscriptionCommand extends Command

  constructor: (@customerid, @subscription) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Org, {customer: @customerid}, {billing: {@subscription}})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeBillingSubscriptionCommand
