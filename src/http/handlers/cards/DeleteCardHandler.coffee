DeleteCardCommand = require 'domain/commands/DeleteCardCommand'
Error             = require 'data/Error'
Handler           = require 'http/framework/Handler'
Response          = require 'http/framework/Response'

class DeleteCardHandler extends Handler

  @route 'delete /api/{organizationId}/cards/{cardId}'
  @demand 'requester is organization member'

  constructor: (@processor) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {user}         = request.auth.credentials
    {cardId}       = request.params

    command = new DeleteCardCommand(cardId)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      reply()

module.exports = DeleteCardHandler
