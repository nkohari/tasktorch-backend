JobHandler                       = require 'apps/worker/framework/JobHandler'
GetOrgByAccountIdQuery           = require 'data/queries/orgs/GetOrgByAccountIdQuery' 
AccountDiscount                  = require 'data/structs/AccountDiscount'
AccountInfo                      = require 'data/structs/AccountInfo'
AccountInvoice                   = require 'data/structs/AccountInvoice'
AccountSource                    = require 'data/structs/AccountSource'
AccountSubscription              = require 'data/structs/AccountSubscription'
Model                            = require 'domain/framework/Model'
SendEmailJob                     = require 'domain/jobs/SendEmailJob'
StripeEventJob                   = require 'domain/jobs/StripeEventJob'
ChangeAccountDiscountCommand     = require 'domain/commands/accounts/ChangeAccountDiscountCommand'
ChangeAccountInfoCommand         = require 'domain/commands/accounts/ChangeAccountInfoCommand'
ChangeAccountSubscriptionCommand = require 'domain/commands/accounts/ChangeAccountSubscriptionCommand'
ChangeAccountSourceCommand       = require 'domain/commands/accounts/ChangeAccountSourceCommand'
DeleteAccountDiscountCommand     = require 'domain/commands/accounts/DeleteAccountDiscountCommand'

class StripeEventHandler extends JobHandler

  handles: StripeEventJob

  constructor: (@log, @database, @processor, @jobQueue, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {event} = job

    @log.debug "[stripe] Received event #{event.id} of type #{event.type}"
    @log.inspect(event, 999)

    @updateAccount event, (err) =>
      if err?
        @log.error "[stripe] Error processing event of type #{event.type}"
        return callback(err)
      @sendEmail event, (err) =>
        if err?
          @log.error "[stripe] Error queueing email jobs for event of type #{event.type}"
          return callback(err)
        callback()

  updateAccount: (event, callback) ->

    switch event.type

      when 'customer.created', 'customer.updated'
        customer = event.data.object
        if not customer.metadata?.org?
          @log.warn "[stripe] Received event of type #{event.type} without metadata, ignoring"
        else
          command = new ChangeAccountInfoCommand(customer.metadata.org, new AccountInfo(customer))

      when 'customer.subscription.created', 'customer.subscription.updated', 'customer.subscription.deleted'
        subscription = event.data.object
        command = new ChangeAccountSubscriptionCommand(subscription.customer, new AccountSubscription(subscription))

      when 'customer.discount.created', 'customer.discount.updated'
        discount = event.data.object
        command = new ChangeAccountDiscountCommand(discount.customer, new AccountDiscount(discount.coupon))

      when 'customer.discount.deleted'
        discount = event.data.object
        command = new DeleteAccountDiscountCommand(discount.customer)

      when 'customer.source.created', 'customer.source.updated'
        source = event.data.object
        command = new ChangeAccountSourceCommand(source.customer, new AccountSource(source))

    if not command?
      callback()
    else
      @processor.execute(command, callback)

  sendEmail: (event, callback) ->

    if event.type == 'customer.subscription.trial_will_end'
      subscription = event.data.object
      @getOrgByAccountId subscription.customer, (err, org) =>
        return callback(err) if err?
        job = new SendEmailJob('trial-warning', {to: org.email}, {
          org: Model.create(org)
        })
        @jobQueue.enqueue(job, callback)

    else if event.type == 'invoice.payment_succeeded'
      invoice = event.data.object
      return callback() unless invoice.amount_due > 0
      @getOrgByAccountId invoice.customer, (err, org) =>
        return callback(err) if err?
        job = new SendEmailJob('receipt', {to: org.email}, {
          org:     Model.create(org)
          invoice: invoice
        })
        @jobQueue.enqueue(job, callback)

    else if event.type == 'invoice.payment_failed'
      invoice = event.data.object
      @getOrgByAccountId invoice.customer, (err, org) =>
        return callback(err) if err?
        # Don't send an email unless the customer has a credit card on their account.
        return callback() unless org.account?.source?
        job = new SendEmailJob('payment-failed', {to: org.email}, {
          org:     Model.create(org)
          invoice: invoice
        })
        @jobQueue.enqueue(job, callback)

    else if event.type == 'customer.subscription.updated'
      subscription = event.data.object
      return callback() unless subscription.cancel_at_period_end
      @getOrgByAccountId subscription.customer, (err, org) =>
        return callback(err) if err?
        job = new SendEmailJob('subscription-pending-cancellation', {to: org.email}, {
          org:     Model.create(org)
          endDate: subscription.current_period_end
        })
        @jobQueue.enqueue(job, callback)

    else if event.type == 'customer.subscription.deleted'
      subscription = event.data.object
      @getOrgByAccountId subscription.customer, (err, org) =>
        return callback(err) if err?
        job = new SendEmailJob('subscription-cancelled', {to: org.email}, {
          org: Model.create(org)
        })
        @jobQueue.enqueue(job, callback)

    else
      callback()

  getOrgByAccountId: (accountId, callback) ->
    query = new GetOrgByAccountIdQuery(accountId)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      unless result.org?
        callback(new Error("Couldn't find an org with account id #{accountId}"))
      else
        callback(null, result.org)

module.exports = StripeEventHandler
