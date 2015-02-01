Handler                  = require 'http/framework/Handler'
ChangeCardSummaryCommand = require 'domain/commands/cards/ChangeCardSummaryCommand'

class ChangeCardSummaryHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/summary'
  
  @pre [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card}    = request.pre
    {user}    = request.auth.credentials
    {summary} = request.payload

    command = new ChangeCardSummaryCommand(user, card.id, summary)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = ChangeCardSummaryHandler
