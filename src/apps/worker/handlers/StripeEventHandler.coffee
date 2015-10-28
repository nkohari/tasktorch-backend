JobHandler                       = require 'apps/worker/framework/JobHandler'
BillingInfo                      = require 'data/structs/BillingInfo'
BillingInvoice                   = require 'data/structs/BillingInvoice'
BillingSource                    = require 'data/structs/BillingSource'
BillingSubscription              = require 'data/structs/BillingSubscription'
StripeEventJob                   = require 'domain/jobs/StripeEventJob'
AddOrChangeBillingInvoiceCommand = require 'domain/commands/billing/AddOrChangeBillingInvoiceCommand'
ChangeBillingInfoCommand         = require 'domain/commands/billing/ChangeBillingInfoCommand'
ChangeBillingSubscriptionCommand = require 'domain/commands/billing/ChangeBillingSubscriptionCommand'
ChangeBillingSourceCommand       = require 'domain/commands/billing/ChangeBillingSourceCommand'

class StripeEventHandler extends JobHandler

  handles: StripeEventJob

  constructor: (@log, @processor, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {event} = job

    @log.debug "[stripe] Received event #{event.id} of type #{event.type}"
    @log.inspect(event, 999)

    command = @createCommand(event)
    unless command?
      @log.debug "[stripe] No command defined for event of type #{event.type}, ignoring"
      return callback()

    @processor.execute(command, callback)

  createCommand: (event) ->

    switch event.type

      when 'customer.created', 'customer.updated'
        customer = event.data.object
        return new ChangeBillingInfoCommand(customer.metadata.org, new BillingInfo(customer))

      when 'customer.subscription.created', 'customer.subscription.updated'
        subscription = event.data.object
        return new ChangeBillingSubscriptionCommand(subscription.customer, new BillingSubscription(subscription))

      when 'customer.source.created', 'customer.source.updated'
        source = event.data.object
        return new ChangeBillingSourceCommand(source.customer, new BillingSource(source))

      when 'invoice.created', 'invoice.updated', 'invoice.payment_succeeded', 'invoice.payment_failed'
        invoice = event.data.object
        return new AddOrChangeBillingInvoiceCommand(invoice.customer, new BillingInvoice(invoice))

    return null

module.exports = StripeEventHandler
