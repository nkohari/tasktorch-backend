Handler                  = require 'http/framework/Handler'
ChangeCardSummaryCommand = require 'domain/commands/cards/ChangeCardSummaryCommand'

class ChangeCardSummaryHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/summary'
  
  @pre [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card}    = request.pre
    {user}    = request.auth.credentials
    {summary} = request.payload

    command = new ChangeCardSummaryCommand(user, card.id, summary)
    @processor.execute command, (err, result) =>
      return reply err if err?
      reply @response(result.card)

module.exports = ChangeCardSummaryHandler
