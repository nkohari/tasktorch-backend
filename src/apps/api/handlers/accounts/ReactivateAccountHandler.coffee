Handler                         = require 'apps/api/framework/Handler'
Model                           = require 'domain/framework/Model'
ReactivateStripeSubscriptionJob = require 'domain/jobs/ReactivateStripeSubscriptionJob'

class ReactivateAccountHandler extends Handler

  @route 'post /{orgid}/account/reactivate'

  @before [
    'resolve org'
    'ensure org has active subscription'
    'ensure requester is leader of org'
  ]
  
  constructor: (@jobQueue) ->

  handle: (request, reply) ->

    {user} = request.auth.credentials
    {org}  = request.pre

    job = new ReactivateStripeSubscriptionJob(Model.create(org))
    @jobQueue.enqueue job, (err) =>
      return reply err if err?
      reply()

module.exports = ReactivateAccountHandler
