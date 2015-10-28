r                      = require 'rethinkdb'
Command                = require 'domain/framework/Command'
Org                    = require 'data/documents/Org'
UpdateByIndexStatement = require 'data/statements/UpdateByIndexStatement'

class AddOrChangeBillingInvoiceCommand extends Command

  constructor: (@customerid, @invoice) ->

  execute: (conn, callback) ->
    statement = new UpdateByIndexStatement(Org,
      {customer: @customerid},
      {billing: {invoices: r.row('billing')('invoices').default({}).merge(r.object(@invoice.id, @invoice))}}
    )
    conn.execute statement, (err, org) =>
      return callback(err) if err?
      callback(null, org)

module.exports = AddOrChangeBillingInvoiceCommand
