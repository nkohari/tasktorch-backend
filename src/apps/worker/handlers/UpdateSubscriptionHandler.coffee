_                                 = require 'lodash'
JobHandler                        = require 'apps/worker/framework/JobHandler'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'
UpdateSubscriptionJob             = require 'domain/jobs/UpdateSubscriptionJob'

class UpdateSubscriptionHandler extends JobHandler

  handles: UpdateSubscriptionJob

  constructor: (@log, @database, @processor, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {orgid} = job

    query = new GetAllActiveMembershipsByOrgQuery(orgid)
    @database.execute query, (err, result) =>

      if err?
        @log.error("Error getting memberships for org #{orgid}: #{err.stack ? err}")
        return callback(err)

      {memberships} = result
      @log.debug "Org #{orgid} now has #{memberships.length} active memberships"

      @updateSubscriptionIfNecessary org, memberships.length, (err) =>

        if err?
          @log.error("Error updating subscription for org #{orgid}: #{err.stack ? err}")
          return callback(err)

        callback()

  updateSubscriptionIfNecessary: (org, memberships, callback) ->

    if not org.account? or not org.account.subscription?
      @log.warn("No account information available for org #{org.id}, can't update subscription")
      return callback()

    if org.account.subscription.seats == memberships.length
      @log.debug("Don't need to update subscription, number of active members hasn't changed")
      return callback()

    customerid     = org.account.id
    subscriptionid = org.account.subscription.id

    @log.debug "Changing subscription quantity from #{org.account.subscription.seats} to #{memberships.length}"
    @stripe.customers.updateSubscription customerid, subscriptionid, {
      quantity: memberships.length
      prorate:  true
    }, callback

module.exports = UpdateSubscriptionHandler
