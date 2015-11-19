Handler            = require 'apps/api/framework/Handler'
DeleteStageCommand = require 'domain/commands/stages/DeleteStageCommand'

class DeleteStageHandler extends Handler

  @route 'delete /{orgid}/stages/{stageid}'

  @ensure
    payload:
      inheritorStage: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve stage'
    'resolve inheritor stage argument'
    'ensure org has active subscription'
    'ensure stage belongs to org'
    'ensure inheritor stage belongs to org'
    'ensure requester can access stage'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org, stage, inheritorStage} = request.pre
    {user} = request.auth.credentials

    command = new DeleteStageCommand(user, stage, inheritorStage)
    @processor.execute command, (err, stage) =>
      return reply err if err?
      return reply @response(stage)

module.exports = DeleteStageHandler
