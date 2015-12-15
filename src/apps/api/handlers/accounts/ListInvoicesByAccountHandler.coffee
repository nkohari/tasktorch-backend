_              = require 'lodash'
Handler        = require 'apps/api/framework/Handler'
AccountInvoice = require 'data/structs/AccountInvoice'

class ListInvoicesByAccountHandler extends Handler

  @route 'get /{orgid}/account/invoices'

  @before [
    'resolve org'
    'ensure org has active subscription'
    'ensure requester is leader of org'
  ]

  constructor: (@database, stripe) ->
    @stripe = stripe.createClient()

  handle: (request, reply) ->

    {org}  = request.pre
    {user} = request.auth.credentials

    customerid = org.account?.id
    unless customerid?
      return reply @error.badRequest("The specified org doesn't have an active account")

    @stripe.invoices.list {customer: customerid, limit: 100}, (err, result) =>
      return reply(err) if err?
      response =
        invoices: _.map result.data, (data) -> new AccountInvoice(org.id, data) 
      reply(response)

module.exports = ListInvoicesByAccountHandler
