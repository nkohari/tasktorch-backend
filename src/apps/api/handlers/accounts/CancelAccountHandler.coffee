Handler                                = require 'apps/api/framework/Handler'
ChangeAccountCancellationReasonCommand = require 'domain/commands/accounts/ChangeAccountCancellationReasonCommand'
Model                                  = require 'domain/framework/Model'
CancelStripeSubscriptionJob            = require 'domain/jobs/CancelStripeSubscriptionJob'

class CancelAccountHandler extends Handler

  @route 'post /{orgid}/account/cancel'

  @ensure
    payload:
      reason: @mustBe.string().allow(null, '').required()

  @before [
    'resolve org'
    'ensure org has active subscription'
    'ensure requester is leader of org'
  ]
  
  constructor: (@processor, @jobQueue) ->

  handle: (request, reply) ->

    {user}   = request.auth.credentials
    {org}    = request.pre
    {reason} = request.payload

    command = new ChangeAccountCancellationReasonCommand(org.id, reason)
    @processor.execute command, (err) =>
      return reply err if err?
      job = new CancelStripeSubscriptionJob(Model.create(org))
      @jobQueue.enqueue job, (err) =>
        return reply err if err?
        reply()

module.exports = CancelAccountHandler
