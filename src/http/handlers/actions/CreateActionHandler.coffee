_                   = require 'lodash'
Handler             = require 'http/framework/Handler'
Action              = require 'data/documents/Action'
GetKindQuery        = require 'data/queries/kinds/GetKindQuery'
CreateActionCommand = require 'domain/commands/actions/CreateActionCommand'

class CreateActionHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/actions'

  @pre [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {org, card}   = request.pre
    {stage, text} = request.payload

    query = new GetKindQuery(card.kind)
    @database.execute query, (err, result) =>
      return reply err if err?

      {kind} = result
      unless _.contains(kind.stages, stage)
        return reply @error.badRequest("Invalid stage #{stage}")

      action = new Action {
        org:   org.id
        card:  card.id
        stage: stage
        text:  text
      }

      command = new CreateActionCommand(request.auth.credentials.user, action)
      @processor.execute command, (err, action) =>
        return reply err if err?
        reply @response(action)

module.exports = CreateActionHandler
