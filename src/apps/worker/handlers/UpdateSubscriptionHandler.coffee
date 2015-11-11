_                                 = require 'lodash'
JobHandler                        = require 'apps/worker/framework/JobHandler'
GetOrgQuery                       = require 'data/queries/orgs/GetOrgQuery'
GetAllActiveMembershipsByOrgQuery = require 'data/queries/memberships/GetAllActiveMembershipsByOrgQuery'
UpdateSubscriptionJob             = require 'domain/jobs/UpdateSubscriptionJob'

class UpdateSubscriptionHandler extends JobHandler

  handles: UpdateSubscriptionJob

  constructor: (@log, @database, @processor, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {orgid} = job

    query = new GetOrgQuery(orgid)
    @database.execute query, (err, result) =>

      if err?
        @log.error("Error getting org #{orgid}: #{err.stack ? err}")
        return callback(err)

      {org} = result
      @log.debug "Updating subscription for org #{org.id}"

      query = new GetAllActiveMembershipsByOrgQuery(org.id)
      @database.execute query, (err, result) =>

        if err?
          @log.error("Error getting memberships for org #{org.id}: #{err.stack ? err}")
          return callback(err)

        {memberships} = result
        @log.debug "Org #{org.id} now has #{memberships.length} active memberships"

        @updateSubscriptionIfNecessary org, memberships, (err) =>

          if err?
            @log.error("Error updating subscription for org #{org.id}: #{err.stack ? err}")
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
