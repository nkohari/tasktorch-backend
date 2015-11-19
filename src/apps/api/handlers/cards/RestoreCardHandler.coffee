Handler                    = require 'apps/api/framework/Handler'
StackType                  = require 'data/enums/StackType'
GetSpecialStackByUserQuery = require 'data/queries/stacks/GetSpecialStackByUserQuery'
RestoreCardCommand          = require 'domain/commands/cards/RestoreCardCommand'

class RestoreCardHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/restore'

  @before [
    'resolve org'
    'resolve card even if deleted'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@database, @processor) ->

  handle: (request, reply) ->

    {card, org} = request.pre
    {user}      = request.auth.credentials

    if card.stack?
      return reply @error.badRequest("You cannot restore a card that is already in a stack")

    query = new GetSpecialStackByUserQuery(org.id, user.id, StackType.Inbox)
    @database.execute query, (err, result) =>
      return reply err if err?
      {stack} = result
      command = new RestoreCardCommand(user, card.id, stack.id)
      @processor.execute command, (err, card) =>
        return reply err if err?
        reply @response(card)

module.exports = RestoreCardHandler
