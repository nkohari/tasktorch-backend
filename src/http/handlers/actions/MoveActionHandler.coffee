_                   = require 'lodash'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'
GetActionQuery    = require 'data/queries/GetActionQuery'
MoveActionCommand = require 'domain/commands/MoveActionCommand'

class MoveActionHandler extends Handler

  @route 'post /api/{organizationId}/actions/{actionId}/move'

  constructor: (@database, @processor) ->

  handle: (request, reply) ->
    @createRequestModel request, (err, model) =>
      return reply err if err?
      @validate request, model, (err) =>
        return reply err if err?
        command = new MoveActionCommand(model.user, model.action.id, model.cardId, model.stageId, model.position)
        @processor.execute command, (err, result) =>
          return reply err if err?
          reply new Response(result.action)

  createRequestModel: (request, callback) ->
    query = new GetActionQuery(request.params.actionId, {expand: 'organization'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.notFound() unless result.action?
      action = result.action
      callback null, {
        user:         request.auth.credentials.user
        action:       action
        organization: result.related.organizations[action.organization]
        cardId:       request.payload.card
        stageId:      request.payload.stage
        position:     request.payload.position
      }

  validate: (request, model, callback) ->
    if model.action.organization != request.params.organizationId
      return callback @error.unauthorized()
    unless _.contains(model.organization.members, model.user.id)
      return callback @error.unauthorized()
    unless model.cardId?.length > 0
      return callback @error.badRequest()
    unless model.stageId?.length > 0
      return callback @error.badRequest()
    callback()

module.exports = MoveActionHandler
