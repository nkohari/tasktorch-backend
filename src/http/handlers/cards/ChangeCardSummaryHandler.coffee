ChangeCardSummaryCommand = require 'domain/commands/card/ChangeCardSummaryCommand'
Error                    = require 'data/Error'
Handler                  = require 'http/framework/Handler'
Response                 = require 'http/framework/Response'

class ChangeCardSummaryCommand extends Handler

  @route  'post /api/{organizationId}/cards/{cardId}/summary'
  @demand 'requester is organization member'

  constructor: (@processor) ->

  handle: (request, reply) ->

    {organization} = request.scope
    {user}         = request.auth.credentials
    {cardId}       = request.params
    {summary}      = request.payload

    command = new ChangeCardSummaryCommand(user, cardId, summary)
    @processor.execute command, (err, result) =>
      return reply @error.notFound() if err is Error.DocumentNotFound
      return reply @error.conflict() if err is Error.VersionMismatch
      return reply err if err?
      reply new Response(result.card)

module.exports = ChangeCardSummaryCommand