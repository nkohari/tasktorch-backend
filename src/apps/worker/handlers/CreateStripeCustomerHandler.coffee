JobHandler              = require 'apps/worker/framework/JobHandler'
CreateStripeCustomerJob = require 'domain/jobs/CreateStripeCustomerJob'

PLAN_ID = 'oct2015'

class CreateStripeCustomerHandler extends JobHandler

  handles: CreateStripeCustomerJob

  constructor: (@log, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {org} = job

    @log.debug "[stripe] Creating Stripe customer for org #{org.id}"

    @stripe.customers.create {
      email:       org.email
      description: org.name
      metadata:    {org: org.id}
    }, (err, customer) =>

      if err?
        @log.error "[stripe] Error creating Stripe customer: #{err.stack ? err}"
        return callback(err)

      @log.debug "[stripe] Customer #{customer.id} created for org #{org.id}"
      @log.debug "[stripe] Creating Stripe subscription for org #{org.id} (customer #{customer.id})"

      @stripe.customers.createSubscription customer.id, {
        plan:     PLAN_ID
        quantity: org.members.length
        metadata: {org: org.id}
      }, (err, subscription) =>

        if err?
          @log.error "[stripe] Error creating Stripe subscription: #{err.stack ? err}"
          return callback(err)

        callback()

module.exports = CreateStripeCustomerHandler
