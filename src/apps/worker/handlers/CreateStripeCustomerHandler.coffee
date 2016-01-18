JobHandler                        = require 'apps/worker/framework/JobHandler'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'
CreateStripeCustomerJob           = require 'domain/jobs/CreateStripeCustomerJob'

PLAN_ID = 'jan2016'

class CreateStripeCustomerHandler extends JobHandler

  handles: CreateStripeCustomerJob

  constructor: (@database, @log, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {org} = job

    @log.debug "[stripe] Creating Stripe customer for org #{org.id}"

    query = new GetAllActiveMembershipsByOrgQuery(org.id)
    @database.execute query, (err, result) =>

      if err?
        @log.error "[stripe] Couldn't count memberships for org #{org.id}: #{err.stack ? err}"
        return callback(err)

      {memberships} = result
      @log.debug "[stripe] Org #{org.id} has #{memberships.length} members"

      @stripe.customers.create {
        email:       org.email
        description: org.name
        plan:        PLAN_ID
        quantity:    memberships.length
        metadata:    {org: org.id}
      }, (err, customer) =>

        if err?
          @log.error "[stripe] Error creating Stripe customer: #{err.stack ? err}"
          return callback(err)

        @log.debug "[stripe] Customer #{customer.id} created for org #{org.id}"
        callback()

module.exports = CreateStripeCustomerHandler
