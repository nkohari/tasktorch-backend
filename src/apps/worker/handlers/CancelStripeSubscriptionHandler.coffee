JobHandler                  = require 'apps/worker/framework/JobHandler'
CancelStripeSubscriptionJob = require 'domain/jobs/CancelStripeSubscriptionJob'

class CancelStripeSubscriptionHandler extends JobHandler

  handles: CancelStripeSubscriptionJob

  constructor: (@database, @log, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {org} = job

    @log.debug "[stripe] Cancelling Stripe subscription for org #{org.id}"

    customerid     = org.account?.id
    subscriptionid = org.account?.subscription?.id

    if not customerid? or not subscriptionid?
      @log.warn "[stripe] No Stripe subscription found for org #{org.id}, nothing to cancel"
      return callback()

    @stripe.customers.cancelSubscription customerid, subscriptionid, {at_period_end: true}, (err) =>

      if err?
        @log.error "[stripe] Error cancelling subscription: #{err.stack ? err}"
        return callback(err)

      @log.debug "[stripe] Stripe subscription #{subscriptionid} cancelled for org #{org.id}"
      callback()

module.exports = CancelStripeSubscriptionHandler
