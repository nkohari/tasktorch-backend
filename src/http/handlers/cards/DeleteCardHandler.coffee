DeleteCardCommand = require 'domain/commands/card/DeleteCardCommand'
Error             = require 'data/Error'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'

class DeleteCardHandler extends Handler

  @route 'delete /api/{orgId}/cards/{cardId}'
  @demand 'requester is org member'

  constructor: (@processor) ->

  handle: (request, reply) ->

    {org}    = request.scope
    {user}   = request.auth.credentials
    {cardId} = request.params

    command = new DeleteCardCommand(user, cardId)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      reply()

module.exports = DeleteCardHandler
