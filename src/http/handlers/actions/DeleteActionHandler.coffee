_                   = require 'lodash'
Handler             = require 'http/framework/Handler'
Response            = require 'http/framework/Response'
GetActionQuery      = require 'data/queries/GetActionQuery'
DeleteActionCommand = require 'domain/commands/action/DeleteActionCommand'

class DeleteActionHandler extends Handler

  @route 'delete /api/{orgId}/actions/{actionId}'

  constructor: (@database, @processor) ->

  handle: (request, reply) ->
    @createRequestModel request, (err, model) =>
      return reply err if err?
      @validate request, model, (err) =>
        return reply err if err?
        command = new DeleteActionCommand(model.user, model.action.id)
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
      }

  validate: (request, model, callback) ->
    if model.action.org != request.params.orgId
      return callback @error.unauthorized()
    unless _.contains(model.org.members, model.user.id)
      return callback @error.unauthorized()
    callback()

module.exports = DeleteActionHandler
