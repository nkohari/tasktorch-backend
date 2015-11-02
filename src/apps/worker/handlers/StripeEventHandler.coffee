JobHandler                       = require 'apps/worker/framework/JobHandler'
AccountInfo                      = require 'data/structs/AccountInfo'
AccountInvoice                   = require 'data/structs/AccountInvoice'
AccountSource                    = require 'data/structs/AccountSource'
AccountSubscription              = require 'data/structs/AccountSubscription'
StripeEventJob                   = require 'domain/jobs/StripeEventJob'
AddOrChangeAccountInvoiceCommand = require 'domain/commands/accounts/AddOrChangeAccountInvoiceCommand'
ChangeAccountInfoCommand         = require 'domain/commands/accounts/ChangeAccountInfoCommand'
ChangeAccountSubscriptionCommand = require 'domain/commands/accounts/ChangeAccountSubscriptionCommand'
ChangeAccountSourceCommand       = require 'domain/commands/accounts/ChangeAccountSourceCommand'

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
        return new ChangeAccountInfoCommand(customer.metadata.org, new AccountInfo(customer))

      when 'customer.subscription.created', 'customer.subscription.updated'
        subscription = event.data.object
        return new ChangeAccountSubscriptionCommand(subscription.customer, new AccountSubscription(subscription))

      when 'customer.source.created', 'customer.source.updated'
        source = event.data.object
        return new ChangeAccountSourceCommand(source.customer, new AccountSource(source))

      when 'invoice.created', 'invoice.updated', 'invoice.payment_succeeded', 'invoice.payment_failed'
        invoice = event.data.object
        return new AddOrChangeAccountInvoiceCommand(invoice.customer, new AccountInvoice(invoice))

    return null

module.exports = StripeEventHandler
