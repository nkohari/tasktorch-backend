Job = require 'domain/framework/Job'

class ReactivateStripeSubscriptionJob extends Job

  constructor: (@org) ->
    super()

module.exports = ReactivateStripeSubscriptionJob
