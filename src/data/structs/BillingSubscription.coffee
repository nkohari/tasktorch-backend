_                         = require 'lodash'
BillingSubscriptionStatus = require 'data/enums/BillingSubscriptionStatus'

class BillingSubscription

  constructor: (data) ->
    @id          = data.id
    @status      = @convertStatus(data.status)
    @seats       = data.quantity
    @willEnd     = data.cancel_at_period_end
    @started     = new Date(data.start * 1000)
    @trialStart  = new Date(data.trial_start * 1000)
    @trialEnd    = new Date(data.trial_end * 1000)
    @periodStart = new Date(data.current_period_start * 1000)
    @periodEnd   = new Date(data.current_period_end * 1000)
    @plan        = {id: data.plan.id, cost: data.plan.amount}

  convertStatus: (str) ->
    switch str
      when 'trialing'  then BillingSubscriptionStatus.Trial
      when 'active'    then BillingSubscriptionStatus.Active
      when 'past_due'  then BillingSubscriptionStatus.PastDue
      when 'canceled'  then BillingSubscriptionStatus.Canceled
      else
        throw new Error("Unknown subscription status #{str}")

module.exports = BillingSubscription
