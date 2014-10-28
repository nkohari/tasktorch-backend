GetCardQuery = require 'data/queries/GetCardQuery'
CardModel    = require '../../models/CardModel'
Handler      = require '../../framework/Handler'

class GetCardHandler extends Handler

  @route 'get /api/{organizationId}/cards/{cardId}'
  @demand 'requester is organization member'

  constructor: (@log, @database) ->

  handle: (request, reply) ->
    {cardId} = request.params
    query    = new GetCardQuery(cardId, @getQueryOptions(request))
    @database.execute query, (err, card) =>
      return reply err if err?
      return reply @error.notFound() unless card?
      reply new CardModel(card, request)

module.exports = GetCardHandler
