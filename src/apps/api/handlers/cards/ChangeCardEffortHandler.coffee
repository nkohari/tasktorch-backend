Handler                 = require 'apps/api/framework/Handler'
ChangeCardEffortCommand = require 'domain/commands/cards/ChangeCardEffortCommand'

class ChangeCardEffortHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/effort'

  @ensure
    payload:
      total:     @mustBe.number().integer().min(1).max(1000)
      remaining: @mustBe.number().integer().min(0).max(1000)
  
  @before [
    'resolve org'
    'resolve card'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card}             = request.pre
    {user}             = request.auth.credentials
    {total, remaining} = request.payload

    if card.effort?
      # If the card already has an effort set, use the existing values to fill in
      # anything not supplied in the request.
      total     = total     ? card.effort.total
      remaining = remaining ? card.effort.remaining
    else
      # If the card doesn't have an effort set and one of the two values isn't specified,
      # use the other value to set them equal.
      total     = total ? remaining
      remaining = remaining ? total

    # Regardless of how we get to the values, remaining can't be greater than total.
    if remaining > total
      return reply @error.badRequest("Remaining effort cannot be greater than total effort")

    command = new ChangeCardEffortCommand(user, card.id, total, remaining)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = ChangeCardEffortHandler
