Handler                  = require 'apps/api/framework/Handler'
ChangeCardDueDateCommand = require 'domain/commands/cards/ChangeCardDueDateCommand'

class ChangeCardDueDateHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/due'

  @ensure
    payload:
      due: @mustBe.date().allow(null).required()
  
  @before [
    'resolve org'
    'resolve card'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card} = request.pre
    {user} = request.auth.credentials
    {due}  = request.payload

    command = new ChangeCardDueDateCommand(user, card.id, due)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = ChangeCardDueDateHandler
