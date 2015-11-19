Handler                = require 'apps/api/framework/Handler'
ChangeStageNameCommand = require 'domain/commands/stages/ChangeStageNameCommand'

class ChangeStageNameHandler extends Handler

  @route 'post /{orgid}/stages/{stageid}/name'

  @ensure
    payload:
      name: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve stage'
    'ensure org has active subscription'
    'ensure stage belongs to org'
    'ensure requester can access stage'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, stage} = request.pre
    {user}      = request.auth.credentials
    {name}      = request.payload

    command = new ChangeStageNameCommand(user, stage, name)
    @processor.execute command, (err, stage) =>
      return reply err if err?
      return reply @response(stage)

module.exports = ChangeStageNameHandler
