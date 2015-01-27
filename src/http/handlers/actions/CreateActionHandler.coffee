_                   = require 'lodash'
Handler             = require 'http/framework/Handler'
Response            = require 'http/framework/Response'
GetCardQuery        = require 'data/queries/GetCardQuery'
CreateActionCommand = require 'domain/commands/action/CreateActionCommand'
Action              = require 'domain/documents/Action'

class CreateActionHandler extends Handler

  @route 'post /api/{orgId}/cards/{cardId}/actions'

  constructor: (@database, @processor) ->

  handle: (request, reply) ->
    @createRequestModel request, (err, model) =>
      return reply err if err?
      @validate request, model, (err) =>
        return reply err if err?
        command = new CreateActionCommand(model.user, model.action, model.card.id)
        @processor.execute command, (err, result) =>
          return reply err if err?
          reply new Response(result.action)

  createRequestModel: (request, callback) ->
    query = new GetCardQuery(request.params.cardId, {expand: ['org', 'kind']})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.notFound() unless result.card?
      card = result.card
      org = result.related.orgs[card.org]
      kind = result.related.kinds[card.kind]
      callback null, {
        card:         card
        org: org
        kind:         kind
        user:         request.auth.credentials.user
        action:       new Action(org.id, card.id, request.payload.stage, request.payload.text)
      }

  validate: (request, model, callback) ->
    if model.card.org != request.params.orgId
      return callback @error.unauthorized()
    unless model.action.stage?.length > 0
      return callback @error.badRequest()
    unless _.contains(model.kind.stages, model.action.stage)
      return callback @error.badRequest()
    callback()

module.exports = CreateActionHandler
