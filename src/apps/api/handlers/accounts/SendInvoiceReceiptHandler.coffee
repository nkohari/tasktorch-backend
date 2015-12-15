Handler      = require 'apps/api/framework/Handler'
Model        = require 'domain/framework/Model'
SendEmailJob = require 'domain/jobs/SendEmailJob'

class SendInvoiceReceiptHandler extends Handler

  @route 'post /{orgid}/account/invoices/{invoiceid}/receipt'

  @before [
    'resolve org'
    'ensure org has active subscription'
    'ensure requester is leader of org'
  ]
  
  constructor: (@jobQueue, stripe) ->
    @stripe = stripe.createClient()

  handle: (request, reply) ->

    {user}      = request.auth.credentials
    {org}       = request.pre
    {invoiceid} = request.params

    @stripe.invoices.retrieve invoiceid, (err, data) =>
      return reply err if err?
      job = new SendEmailJob('receipt', {to: org.email}, {
        org:     Model.create(org)
        invoice: data
      })
      @jobQueue.enqueue job, (err) =>
        return reply err if err?
        reply()

module.exports = SendInvoiceReceiptHandler
