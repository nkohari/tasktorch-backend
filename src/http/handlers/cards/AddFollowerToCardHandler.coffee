_                        = require 'lodash'
Handler                  = require 'http/framework/Handler'
AddFollowerToCardCommand = require 'domain/commands/cards/AddFollowerToCardCommand'

class AddFollowerToCardHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/followers'

  @ensure
    payload:
      user: @mustBe.string().required()

  @before [
    'resolve org'
    'resolve card'
    'resolve user argument'
    'ensure card belongs to org'
    'ensure requester is user'
    'ensure requester can access card'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card, org, user} = request.pre
    requester         = request.auth.credentials.user

    if _.contains(card.followers, user.id)
      return reply @response(card)

    command = new AddFollowerToCardCommand(requester, card, user)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = AddFollowerToCardHandler
