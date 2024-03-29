_                         = require 'lodash'
AccountSubscriptionStatus = require 'data/enums/AccountSubscriptionStatus'

class AccountSubscription

  constructor: (data) ->
    @id          = data.id
    @status      = @convertStatus(data)
    @seats       = data.quantity
    @started     = new Date(data.start * 1000)
    @trialStart  = new Date(data.trial_start * 1000)
    @trialEnd    = new Date(data.trial_end * 1000)
    @periodStart = new Date(data.current_period_start * 1000)
    @periodEnd   = new Date(data.current_period_end * 1000)
    @plan        = {id: data.plan.id, cost: data.plan.amount}

  convertStatus: (data) ->
    if data.cancel_at_period_end
      return AccountSubscriptionStatus.CancellationPending
    switch data.status
      when 'trialing'  then AccountSubscriptionStatus.Trial
      when 'active'    then AccountSubscriptionStatus.Active
      when 'past_due'  then AccountSubscriptionStatus.PastDue
      when 'canceled'  then AccountSubscriptionStatus.Canceled
      else
        throw new Error("Unknown subscription status #{data.status}")

module.exports = AccountSubscription
