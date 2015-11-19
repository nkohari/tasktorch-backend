Handler                = require 'apps/api/framework/Handler'
ChangeCardTitleCommand = require 'domain/commands/cards/ChangeCardTitleCommand'

class ChangeCardTitleHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/title'

  @ensure
    payload:
      title: @mustBe.string().allow(null, '').required()

  @before [
    'resolve org'
    'resolve card'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card}  = request.pre
    {user}  = request.auth.credentials
    {title} = request.payload

    command = new ChangeCardTitleCommand(user, card.id, title)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)
        
module.exports = ChangeCardTitleHandler
