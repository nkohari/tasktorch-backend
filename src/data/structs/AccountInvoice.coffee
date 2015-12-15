_ = require 'lodash'

class AccountInvoice

  constructor: (org, data) ->
    @id              = data.id
    @org             = org
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
    @periodStart     = new Date(data.period_start * 1000)
    @periodEnd       = new Date(data.period_end * 1000)

module.exports = AccountInvoice
