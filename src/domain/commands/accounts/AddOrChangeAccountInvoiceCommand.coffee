r                      = require 'rethinkdb'
Command                = require 'domain/framework/Command'
Org                    = require 'data/documents/Org'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class AddOrChangeAccountInvoiceCommand extends Command

  constructor: (@accountid, @invoice) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Org,
      {account: @accountid},
      {account: {invoices: r.row('account')('invoices').default({}).merge(r.object(@invoice.id, @invoice))}}
    )
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = AddOrChangeAccountInvoiceCommand
