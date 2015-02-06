Handler           = require 'http/framework/Handler'
DeleteCardCommand = require 'domain/commands/cards/DeleteCardCommand'

class DeleteCardHandler extends Handler

  @route 'delete /api/{orgid}/cards/{cardid}'

  @before [
    'resolve org'
    'resolve card'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@processor) ->

  handle: (request, reply) ->

    {card} = request.pre
    {user} = request.auth.credentials

    command = new DeleteCardCommand(user, card)
    @processor.execute command, (err, card) =>
      return reply err if err?
      return reply @response(card)

module.exports = DeleteCardHandler
