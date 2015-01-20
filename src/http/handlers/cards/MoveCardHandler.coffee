_               = require 'lodash'
MoveCardCommand = require 'domain/commands/card/MoveCardCommand'
Handler         = require 'http/framework/Handler'
Response        = require 'http/framework/Response'
MoveCardRequest = require 'http/requests/MoveCardRequest'

class MoveCardHandler extends Handler

  @route 'post /api/{organizationId}/cards/{cardId}/move'

  constructor: (@forge, @database, @processor) ->

  handle: (request, reply) ->
    @createRequestModel request, (err, req) =>
      return reply err if err?

      # TODO: Move to demand
      unless _.contains(req.organization.members, req.user.id)
        return reply @error.unauthorized("You do not have access to that organization")

      if req.stack.team? and not _.contains(req.team.members, req.user.id)
        return reply @error.unauthorized("You cannot move a card to a stack owned by a team of which you are not a member")

      if req.stack.user? and req.stack.user != req.user.id
        return reply @error.unauthorized("You cannot move a card to a stack owned by another user")

      command = new MoveCardCommand(req.user, req.card.id, req.stack.id, req.position)
      @processor.execute command, (err, result) =>
        return reply @error.notFound() if err is Error.DocumentNotFound
        return reply @error.conflict() if err is Error.VersionMismatch
        return reply err if err?
        reply new Response(result.card)

  # TODO: This should be part of how Handlers work, via something like:
  #
  # class MoveCardHandler
  #   @request MoveCardRequest
  # 
  createRequestModel: (request, callback) ->
    model = @forge.create(MoveCardRequest)
    model.interpret request, (err) =>
      return callback(err) if err?
      callback(null, model)

module.exports = MoveCardHandler
