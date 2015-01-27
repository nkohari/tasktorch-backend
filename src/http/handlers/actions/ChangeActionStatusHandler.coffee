_                         = require 'lodash'
Handler                   = require 'http/framework/Handler'
Response                  = require 'http/framework/Response'
GetActionQuery            = require 'data/queries/GetActionQuery'
ChangeActionStatusCommand = require 'domain/commands/action/ChangeActionStatusCommand'
ActionStatus              = require 'domain/enums/ActionStatus'

class ChangeActionStatusHandler extends Handler

  @route 'post /api/{orgId}/actions/{actionId}/status'

  constructor: (@database, @processor) ->

  handle: (request, reply) ->
    @createRequestModel request, (err, model) =>
      return reply err if err?
      @validate request, model, (err) =>
        return reply err if err?
        command = new ChangeActionStatusCommand(model.user, model.action.id, model.status)
        @processor.execute command, (err, result) =>
          return reply err if err?
          reply new Response(result.action)

  createRequestModel: (request, callback) ->
    query = new GetActionQuery(request.params.actionId, {expand: 'org'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.notFound() unless result.action?
      action = result.action
      callback null, {
        user:         request.auth.credentials.user
        action:       action
        org: result.related.orgs[action.org]
        status:       request.payload.status
      }

  validate: (request, model, callback) ->
    if model.action.org != request.params.orgId
      return callback @error.unauthorized()
    unless _.contains(model.org.members, model.user.id)
      return callback @error.unauthorized()
    unless model.status?.length > 0 and ActionStatus[model.status]?
      return callback @error.badRequest("Couldn't understand action status #{model.status}")
    callback()

module.exports = ChangeActionStatusHandler
