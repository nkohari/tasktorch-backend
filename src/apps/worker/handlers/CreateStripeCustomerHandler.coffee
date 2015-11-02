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
      plan:        PLAN_ID
      quantity:    org.members.length
      metadata:    {org: org.id}
    }, (err, customer) =>

      if err?
        @log.error "[stripe] Error creating Stripe customer: #{err.stack ? err}"
        return callback(err)

      @log.debug "[stripe] Customer #{customer.id} created for org #{org.id}"
      callback()

module.exports = CreateStripeCustomerHandler
