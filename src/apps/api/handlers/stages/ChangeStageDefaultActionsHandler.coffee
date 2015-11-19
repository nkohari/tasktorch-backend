Handler                          = require 'apps/api/framework/Handler'
ChangeStageDefaultActionsCommand = require 'domain/commands/stages/ChangeStageDefaultActionsCommand'

class ChangeStageDefaultActionsHandler extends Handler

  @route 'post /{orgid}/stages/{stageid}/defaultActions'

  @ensure
    payload:
      defaultActions: @mustBe.array().items {text: @mustBe.string()}

  @before [
    'resolve org'
    'resolve stage'
    'ensure org has active subscription'
    'ensure stage belongs to org'
    'ensure requester can access stage'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, stage}     = request.pre
    {user}           = request.auth.credentials
    {defaultActions} = request.payload

    command = new ChangeStageDefaultActionsCommand(user, stage, defaultActions)
    @processor.execute command, (err, stage) =>
      return reply err if err?
      return reply @response(stage)

module.exports = ChangeStageDefaultActionsHandler
