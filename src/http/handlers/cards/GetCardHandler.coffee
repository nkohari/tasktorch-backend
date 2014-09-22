CardModel = require '../../models/CardModel'
Handler   = require '../../framework/Handler'

class GetCardHandler extends Handler

  @route 'get /organizations/{organizationId}/cards/{cardId}'

  constructor: (log, @cardService) ->
    super(log)

  handle: (request, reply) ->
    {cardId} = request.params
    expand   = request.query.expand.split(',') if request.query.expand?.length > 0
    @cardService.get cardId, {expand}, (err, card) =>
      return reply @error(err) if err?
      return reply @notFound() unless card?
      reply new CardModel(card)

module.exports = GetCardHandler
