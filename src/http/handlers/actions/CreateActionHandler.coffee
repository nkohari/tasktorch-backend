_                   = require 'lodash'
Handler             = require 'http/framework/Handler'
Action              = require 'data/documents/Action'
GetKindQuery        = require 'data/queries/kinds/GetKindQuery'
CreateActionCommand = require 'domain/commands/actions/CreateActionCommand'

class CreateActionHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/actions'

  @ensure
    payload:
      text:  @mustBe.string().allow(null).required()
      stage: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve card'
    'resolve stage argument'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, card, stage} = request.pre
    {text}             = request.payload
    {user}             = request.auth.credentials

    query = new GetKindQuery(card.kind)
    @database.execute query, (err, result) =>
      return reply err if err?

      {kind} = result
      unless kind.hasStage(stage.id)
        return reply @error.badRequest("Stage #{stage.id} is not part of the kind #{kind.id}")

      action = new Action {
        org:   org.id
        card:  card.id
        stage: stage.id
        text:  text
      }

      command = new CreateActionCommand(user, action)
      @processor.execute command, (err, action) =>
        return reply err if err?
        reply @response(action)

module.exports = CreateActionHandler
