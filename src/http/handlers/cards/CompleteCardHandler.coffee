Handler             = require 'http/framework/Handler'
CompleteCardCommand = require 'domain/commands/cards/CompleteCardCommand'

class ArchiveCardHandler extends Handler

  @route 'post /api/{orgid}/cards/{cardid}/complete'
  
  @pre [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester is member of org'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card} = request.pre
    {user} = request.auth.credentials

    command = new CompleteCardCommand(user, card.id)
    @processor.execute command, (err, card) =>
      return reply err if err?
      reply @response(card)

module.exports = ArchiveCardHandler