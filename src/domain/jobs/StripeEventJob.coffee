Job = require 'domain/framework/Job'

class StripeEventJob extends Job

  constructor: (@event) ->
    super()

module.exports = StripeEventJob
