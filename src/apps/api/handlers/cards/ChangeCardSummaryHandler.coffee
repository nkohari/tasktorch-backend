Handler                  = require 'apps/api/framework/Handler'
ChangeCardSummaryCommand = require 'domain/commands/cards/ChangeCardSummaryCommand'

class ChangeCardSummaryHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/summary'

  @ensure
    payload:
      summary: @mustBe.string().allow(null, '').required()
  
  @before [
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
