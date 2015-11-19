Precondition              = require 'apps/api/framework/Precondition'
AccountSubscriptionStatus = require 'data/enums/AccountSubscriptionStatus'

class EnsureOrgHasActiveSubscription extends Precondition

  execute: (request, reply) ->
    {org} = request.pre
    if not org?
      return reply()
    else if org.account?.subscription?.status isnt AccountSubscriptionStatus.Canceled
      return reply()
    else
      return reply @error.create(402, "The org #{org.id} has no active subscription")

module.exports = EnsureOrgHasActiveSubscription
