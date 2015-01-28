Handler                    = require 'http/framework/Handler'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'
AcceptCardCommand          = require 'domain/commands/cards/AcceptCardCommand'

class AcceptCardHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/accept'

  @pre [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card, org} = request.pre
    {user}      = request.auth.credentials

    if card.owner? and card.owner != user.id
      return reply @error.unauthorized("You cannot accept a card that is owned by another user")

    query = new GetSpecialStackByUserQuery(org.id, user.id)
    @database.execute query, (err, result) =>
      return reply err if err?
      {stack} = result
      command = new AcceptCardCommand(user, card.id, stack.id)
      @processor.execute command, (err, result) =>
        return reply err if err?
        reply @response(result.card)

module.exports = AcceptCardHandler
