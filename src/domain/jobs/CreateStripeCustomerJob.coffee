Job = require 'domain/framework/Job'

class CreateStripeCustomerJob extends Job

  constructor: (@org) ->
    super()

module.exports = CreateStripeCustomerJob
