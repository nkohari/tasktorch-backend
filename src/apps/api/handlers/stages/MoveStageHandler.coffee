Handler          = require 'apps/api/framework/Handler'
MoveStageCommand = require 'domain/commands/stages/MoveStageCommand'

class MoveStageHandler extends Handler

  @route 'post /{orgid}/stages/{stageid}/move'

  @ensure
    payload:
      position: @mustBe.number().integer().allow('prepend', 'append')

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
    {user}       = request.auth.credentials
    {position}   = request.payload

    command = new MoveStageCommand(user, stage, position)
    @processor.execute command, (err, stage) =>
      return reply err if err?
      return reply @response(stage)

module.exports = MoveStageHandler
