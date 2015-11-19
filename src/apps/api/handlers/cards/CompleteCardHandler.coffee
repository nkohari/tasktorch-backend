Handler             = require 'apps/api/framework/Handler'
CompleteCardCommand = require 'domain/commands/cards/CompleteCardCommand'

class ArchiveCardHandler extends Handler

  @route 'post /{orgid}/cards/{cardid}/complete'
  
  @before [
    'resolve org'
    'resolve card'
    'ensure org has active subscription'
    'ensure card belongs to org'
    'ensure requester can access card'
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
