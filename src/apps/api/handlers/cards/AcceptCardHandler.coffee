Handler                    = require 'apps/api/framework/Handler'
StackType                  = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'
AcceptCardCommand          = require 'domain/commands/cards/AcceptCardCommand'

class AcceptCardHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/accept'

  @ensure
    payload:
      preempt: @mustBe.boolean().default(false)

  @before [
    'resolve org'
    'resolve card'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {card, org} = request.pre
    {user}      = request.auth.credentials
    {preempt}   = request.payload

    if card.user? and card.user != user.id
      return reply @error.badRequest("You cannot accept a card that is owned by another user")

    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Queue)
    @database.execute query, (err, result) =>
      return reply err if err?
      {stack} = result
      command = new AcceptCardCommand(user, card.id, stack.id, preempt)
      @processor.execute command, (err, card) =>
        return reply err if err?
        reply @response(card)

module.exports = AcceptCardHandler
