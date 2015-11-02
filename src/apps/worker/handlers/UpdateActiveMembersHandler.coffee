_                             = require 'lodash'
JobHandler                    = require 'apps/worker/framework/JobHandler'
Org                           = require 'data/documents/Org'
GetOrgQuery                   = require 'data/queries/orgs/GetOrgQuery'
GetAllActiveMembersByOrgQuery = require 'data/queries/users/GetAllActiveMembersByOrgQuery'
UpdateActiveMembersJob        = require 'domain/jobs/UpdateActiveMembersJob'
ChangeOrgActiveMembersCommand = require 'domain/commands/orgs/ChangeOrgActiveMembersCommand'

class UpdateActiveMembersHandler extends JobHandler

  handles: UpdateActiveMembersJob

  constructor: (@log, @database, @processor, stripe) ->
    super()
    @stripe = stripe.createClient()

  handle: (job, callback) ->

    {orgid} = job

    @log.debug "Checking active members for org #{orgid}"
    query = new GetOrgQuery(orgid)
    @database.execute query, (err, result) =>

      if err?
        @log.error("Error getting org #{orgid}: #{err.stack ? err}")
        return callback(err)

      {org} = result

      @log.debug "Org #{org.id} currently has #{org.activeMembers.length} active members, getting new count"
      query = new GetAllActiveMembersByOrgQuery(org.id)
      @database.execute query, (err, result) =>

        if err?
          @log.error("Error getting active members for org #{orgid}: #{err.stack ? err}")
          return callback(err)

        activeMembers = _.map result.users, (u) -> u.id
        @log.debug "Org #{orgid} now has #{activeMembers.length} active members"

        @updateSubscriptionIfNecessary org, activeMembers, (err) =>

          if err?
            @log.error("Error updating subscription: #{err.stack ? err}")
            return callback(err)

          @updateOrgIfNecessary org, activeMembers, (err) =>

            if err?
              @log.error("Error updating org: #{err.stack ? err}")
              return callback(err)

            @log.debug "Finished processing org #{org.id}"
            callback()

  updateSubscriptionIfNecessary: (org, activeMembers, callback) ->

    if not org.account? or not org.account.subscription?
      @log.warn("No account information available for org #{org.id}, can't update subscription")
      return callback()

    if org.account.subscription.seats == activeMembers.length
      @log.debug("Don't need to update subscription, number of active members hasn't changed")
      return callback()

    customerid     = org.account.id
    subscriptionid = org.account.subscription.id

    @log.debug "Changing subscription quantity from #{org.account.subscription.seats} to #{activeMembers.length}"
    @stripe.customers.updateSubscription customerid, subscriptionid, {
      quantity: activeMembers.length
      prorate:  true
    }, callback

  updateOrgIfNecessary: (org, activeMembers, callback) ->

    if _.isEmpty(_.difference(org.activeMembers, activeMembers))
      @log.debug "Don't need to update org, active members haven't changed"
      return callback()

    @log.debug "Updating org to reflect new active members"
    command = new ChangeOrgActiveMembersCommand(org.id, activeMembers)
    @processor.execute(command, callback)

module.exports = UpdateActiveMembersHandler
