Handler        = require 'apps/api/framework/Handler'
StripeEventJob = require 'domain/jobs/StripeEventJob'

class StripeWebhookHandler extends Handler

  @route 'post /_stripe'
  @auth  false

  constructor: (@log, stripe, @jobQueue) ->
    @stripe = stripe.createClient()

  handle: (request, reply) ->

    {id} = request.payload

    unless id?.length > 0
      return reply @error.badRequest()

    @stripe.events.retrieve id, (err, event) =>

      if err?
        @log.error "Error while retrieving event from Stripe: #{err}"
        return reply @error.badRequest()

      unless event?
        @log.error "Ignoring received Stripe event with invalid id #{id}"
        return reply @error.badRequest()

      @log.debug "Creating StripeEventJob for Stripe event #{id} of type #{event.type}"
      job = new StripeEventJob(event)
      @jobQueue.enqueue job, (err) =>
        reply()

module.exports = StripeWebhookHandler
