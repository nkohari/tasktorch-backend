_                             = require 'lodash'
Handler                       = require 'http/framework/Handler'
RemoveFollowerFromCardCommand = require 'domain/commands/cards/RemoveFollowerFromCardCommand'

class RemoveFollowerFromCardHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/followers/{userid}'

  @before [
    'resolve org'
    'resolve card'
    'resolve user'
    'ensure card belongs to org'
    'ensure requester is user'
    'ensure requester can access card'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card, org, user} = request.pre
    requester         = request.auth.credentials.user

    unless _.contains(card.followers, user.id)
      return reply @response(card)

    command = new RemoveFollowerFromCardCommand(requester, card, user)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = RemoveFollowerFromCardHandler
