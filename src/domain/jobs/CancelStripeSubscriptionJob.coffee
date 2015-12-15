Job = require 'domain/framework/Job'

class CancelStripeSubscriptionJob extends Job

  constructor: (@org) ->
    super()

module.exports = CancelStripeSubscriptionJob
