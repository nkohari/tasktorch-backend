_ = require 'lodash'

class BillingInvoice

  constructor: (data) ->
    @id              = data.id
    @timestamp       = new Date(data.date * 1000)
    @startingBalance = data.starting_balance
    @endingBalance   = data.ending_balance
    @amount          = data.amount_due
    @subtotal        = data.subtotal
    @total           = data.total
    @attempted       = data.attempted
    @closed          = data.closed
    @forgiven        = data.forgiven
    @paid            = data.paid
    @receipt         = data.receipt_number
    @periodStart     = new Date(data.period_start * 1000)
    @periodEnd       = new Date(data.period_end * 1000)

module.exports = BillingInvoice
