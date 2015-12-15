JobHandler                      = require 'apps/worker/framework/JobHandler'
ReactivateStripeSubscriptionJob = require 'domain/jobs/ReactivateStripeSubscriptionJob'

class ReactivateStripeSubscriptionHandler extends JobHandler

  handles: ReactivateStripeSubscriptionJob

  constructor: (@database, @log, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {org} = job

    @log.debug "[stripe] Reactivating Stripe subscription for org #{org.id}"

    customerid     = org.account?.id
    subscriptionid = org.account?.subscription?.id
    planid         = org.account?.subscription?.plan?.id

    if not customerid? or not subscriptionid? or not planid?
      @log.warn "[stripe] No Stripe subscription found for org #{org.id}, nothing to reactivate"
      return callback()

    @stripe.customers.updateSubscription customerid, subscriptionid, {plan: planid}, (err) =>

      if err?
        @log.error "[stripe] Error reactivating subscription: #{err.stack ? err}"
        return callback(err)

      @log.debug "[stripe] Stripe subscription #{subscriptionid} reactivated for org #{org.id}"
      callback()

module.exports = ReactivateStripeSubscriptionHandler
