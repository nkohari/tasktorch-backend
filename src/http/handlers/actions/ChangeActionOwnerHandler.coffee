_                        = require 'lodash'
Handler                  = require 'http/framework/Handler'
Response                 = require 'http/framework/Response'
GetActionQuery           = require 'data/queries/GetActionQuery'
GetUserQuery             = require 'data/queries/GetUserQuery'
ChangeActionOwnerCommand = require 'domain/commands/action/ChangeActionOwnerCommand'

class ChangeActionOwnerHandler extends Handler

  @route 'post /api/{orgId}/actions/{actionId}/owner'

  constructor: (@database, @processor) ->

  handle: (request, reply) ->
    @createRequestModel request, (err, model) =>
      return reply err if err?
      @validate request, model, (err) =>
        return reply err if err?
        command = new ChangeActionOwnerCommand(model.user, model.action.id, model.owner)
        @processor.execute command, (err, result) =>
          return reply err if err?
          reply new Response(result.action)

  createRequestModel: (request, callback) ->
    @loadRequestData request, [@getAction, @getOwner], (err, data) =>
      return callback(err) if err?
      callback null, {
        user:   request.auth.credentials.user
        action: data.action
        org:    data.org
        owner:  data.owner
      }

  getAction: (request, callback) ->
    query = new GetActionQuery(request.params.actionId, {expand: 'org'})
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.notFound() unless result.action?
      action = result.action
      org    = result.related.orgs[action.org]
      callback null, {action, org}

  getOwner: (request, callback) ->
    if request.payload.user is undefined
      return callback @error.badRequest("Missing parameter 'user' on request")
    if request.payload.user is null
      return callback(null, null)
    query = new GetUserQuery(request.payload.user)
    @database.execute query, (err, result) =>
      return callback(err) if err?
      return callback @error.badRequest("Couldn't find a user with the id #{request.payload.user}") unless result.user?
      owner = result.user
      callback null, {owner}

  validate: (request, model, callback) ->
    if model.action.org != request.params.orgId
      return callback @error.unauthorized()
    unless _.contains(model.org.members, model.user.id)
      return callback @error.unauthorized()
    callback()

module.exports = ChangeActionOwnerHandler
