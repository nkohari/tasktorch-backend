ChangeCardBodyCommand = require 'domain/commands/card/ChangeCardBodyCommand'
Error                 = require 'data/Error'
Handler               = require 'http/framework/Handler'
Response              = require 'http/framework/Response'

class ChangeCardBodyHandler extends Handler

  @route  'post /api/{organizationId}/cards/{cardId}/body'
  @demand 'requester is organization member'

  constructor: (@processor) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {user}         = request.auth.credentials
    {cardId}       = request.params
    {body}         = request.payload

    command = new ChangeCardBodyCommand(user, cardId, body)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      reply new Response(result.card)

module.exports = ChangeCardBodyHandler
