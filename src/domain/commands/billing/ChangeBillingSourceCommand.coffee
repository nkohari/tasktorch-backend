Command                = require 'domain/framework/Command'
Org                    = require 'data/documents/Org'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class ChangeBillingSourceCommand extends Command

  constructor: (@customerid, @source) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Org, {customer: @customerid}, {billing: {@source}})
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = ChangeBillingSourceCommand
