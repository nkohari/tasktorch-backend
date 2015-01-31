_                 = require 'lodash'
Handler           = require 'http/framework/Handler'
GetKindQuery      = require 'data/queries/kinds/GetKindQuery'
MoveActionCommand = require 'domain/commands/actions/MoveActionCommand'

class MoveActionHandler extends Handler

  @route 'post /api/{orgid}/actions/{actionid}/move'

  @pre [
    'resolve org'
    'resolve action'
    'resolve card argument'
    'resolve stage argument'
    'ensure action belongs to org'
    'ensure requester is member of org'
    'ensure position argument is valid'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {action, card, stage} = request.pre
    {position}            = request.payload

    query = new GetKindQuery(card.kind)
    @database.execute query, (err, result) =>
      return reply err if err?

      kind = result.kind
      unless _.contains(kind.stages, stage.id)
        return reply @error.badRequest("Stage #{stage.id} is not part of the kind #{kind.id}")

      command = new MoveActionCommand(request.auth.credentials.user, action.id, card.id, stage.id, position)
      @processor.execute command, (err, action) =>
        return reply err if err?
        reply @response(action)

module.exports = MoveActionHandler
