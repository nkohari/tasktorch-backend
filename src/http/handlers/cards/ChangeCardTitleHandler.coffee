Handler                = require 'http/framework/Handler'
ChangeCardTitleCommand = require 'domain/commands/cards/ChangeCardTitleCommand'

class ChangeCardTitleHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/title'

  @pre [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester is member of org'
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
