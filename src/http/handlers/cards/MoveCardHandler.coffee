_               = require 'lodash'
Handler         = require 'http/framework/Handler'
MoveCardCommand = require 'domain/commands/cards/MoveCardCommand'

class MoveCardHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/move'

  @validate
    payload:
      stack:    @mustBe.string().required()
      position: @mustBe.number().integer().allow('prepend', 'append').required()

  @pre [
    'resolve org'
    'resolve card'
    'resolve stack argument'
    'resolve team by stack'
    'ensure requester can access card'
    'ensure requester can access stack'    
    'ensure position argument is valid'
  ]

  constructor: (@forge, @database, @processor) ->

  handle: (request, reply) ->

    {org, card, stack, team} = request.pre
    {user}                   = request.auth.credentials
    {position}               = request.payload

    if team? and not team.hasMember(user.id)
      return reply @error.forbidden("You cannot move a card to a stack owned by a team of which you are not a member")

    if stack.user? and stack.user != user.id
      return reply @error.forbidden("You cannot move a card to a stack owned by another user")

    command = new MoveCardCommand(user, card.id, stack.id, position)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = MoveCardHandler
