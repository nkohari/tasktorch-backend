_                 = require 'lodash'
AcceptCardCommand = require 'domain/commands/AcceptCardCommand'
AcceptCardRequest = require 'http/requests/AcceptCardRequest'
Error             = require 'data/Error'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'

class AcceptCardHandler extends Handler

  @route 'post /api/{organizationId}/cards/{cardId}/accept'

  constructor: (@forge, @processor) ->

  handle: (request, reply) ->

    @createRequestModel request, (err, req) =>
      return reply err if err?

      # TODO: Move to demand
      unless _.contains(req.organization.members, req.user.id)
        return reply @error.unauthorized("You do not have access to that organization")

      # TODO: Move to demand
      if req.card.owner? and req.card.owner != req.user.id
        return reply @error.unauthorized("You cannot accept a card that is owned by another user")

      command = new AcceptCardCommand(req.user, req.card.id, req.stack.id)
      console.log(command)

      @processor.execute command, (err, result) =>
        return reply @error.notFound() if err is Error.DocumentNotFound
        return reply @error.conflict() if err is Error.VersionMismatch
        return reply err if err?
        reply new Response(result.card)

  # TODO: This should be part of how Handlers work.
  createRequestModel: (request, callback) ->
    model = @forge.create(AcceptCardRequest)
    model.interpret request, (err) =>
      return callback(err) if err?
      callback(null, model)

module.exports = AcceptCardHandler
