GetCardQuery           = require 'data/queries/GetCardQuery'
ChangeCardTitleCommand = require 'domain/commands/card/ChangeCardTitleCommand'
Error                  = require 'data/Error'
Handler                = require 'http/framework/Handler'
Response               = require 'http/framework/Response'

class ChangeCardTitleHandler extends Handler

  @route  'post /api/{organizationId}/cards/{cardId}/title'
  @demand 'requester is organization member'

  constructor: (@processor) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {user}         = request.auth.credentials
    {cardId}       = request.params
    {title}        = request.payload

    command = new ChangeCardTitleCommand(user, cardId, title)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      reply new Response(result.card)
        
module.exports = ChangeCardTitleHandler
