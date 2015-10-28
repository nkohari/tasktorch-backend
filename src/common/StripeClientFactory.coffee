stripe = require 'stripe'

class StripeClientFactory

  constructor: (@config) ->

  createClient: ->
    stripe(@config.stripe.secretKey)

module.exports = StripeClientFactory