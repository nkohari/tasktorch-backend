CardModel = require '../../models/CardModel'
Handler   = require '../../framework/Handler'

class GetCardHandler extends Handler

  @route 'get /organizations/{organizationId}/cards/{cardId}'

  constructor: (@cardService) ->

  handle: (request, reply) ->
    {cardId} = request.params
    expand   = request.query.expand.split(',') if request.query.expand?.length > 0
    @cardService.get cardId, {expand}, (err, card) =>
      return reply err if err?
      return reply @error.notFound() unless card?
      reply new CardModel(card)

module.exports = GetCardHandler
