CompleteCardCommand = require 'domain/commands/CompleteCardCommand'
Error               = require 'data/Error'
Handler             = require 'http/framework/Handler'
Response            = require 'http/framework/Response'

class ArchiveCardHandler extends Handler

  @route  'post /api/{organizationId}/cards/{cardId}/complete'
  @demand 'requester is organization member'

  constructor: (@processor) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {user}         = request.auth.credentials
    {cardId}       = request.params

    command = new CompleteCardCommand(user, cardId)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      reply new Response(result.card)

module.exports = ArchiveCardHandler