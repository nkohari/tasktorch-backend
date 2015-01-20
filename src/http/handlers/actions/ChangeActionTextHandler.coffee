_                       = require 'lodash'
Handler                 = require 'http/framework/Handler'
Response                = require 'http/framework/Response'
GetActionQuery          = require 'data/queries/GetActionQuery'
ChangeActionTextCommand = require 'domain/commands/action/ChangeActionTextCommand'

class ChangeActionTextHandler extends Handler

  @route 'post /api/{organizationId}/actions/{actionId}/text'

  constructor: (@database, @processor) ->

  handle: (request, reply) ->
    @createRequestModel request, (err, model) =>
      return reply err if err?
      @validate request, model, (err) =>
        return reply err if err?
        command = new ChangeActionTextCommand(model.user, model.action.id, model.text)
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
        text:         request.payload.text
      }

  validate: (request, model, callback) ->
    if model.action.organization != request.params.organizationId
      return callback @error.unauthorized()
    unless _.contains(model.organization.members, model.user.id)
      return callback @error.unauthorized()
    unless model.text?.length > 0
      return callback @error.badRequest()
    callback()

module.exports = ChangeActionTextHandler
