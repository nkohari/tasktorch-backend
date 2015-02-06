Handler                    = require 'http/framework/Handler'
StackType                  = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'
AcceptCardCommand          = require 'domain/commands/cards/AcceptCardCommand'

class AcceptCardHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/accept'

  @before [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {card, org} = request.pre
    {user}      = request.auth.credentials

    if card.owner? and card.owner != user.id
      return reply @error.badRequest("You cannot accept a card that is owned by another user")

    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Queue)
    @database.execute query, (err, result) =>
      return reply err if err?
      {stack} = result
      command = new AcceptCardCommand(user, card.id, stack.id)
      @processor.execute command, (err, card) =>
        return reply err if err?
        reply @response(card)

module.exports = AcceptCardHandler
