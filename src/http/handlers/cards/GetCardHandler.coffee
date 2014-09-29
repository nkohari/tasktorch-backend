{Card}    = require 'data/entities'
GetQuery  = require 'data/queries/GetQuery'
CardModel = require '../../models/CardModel'
Handler   = require '../../framework/Handler'

class GetCardHandler extends Handler

  @route 'get /organizations/{organizationId}/cards/{cardId}'

  constructor: (@database) ->

  handle: (request, reply) ->

    {cardId} = request.params
    expand   = request.query.expand?.split(',')

    query = new GetQuery(Card, cardId, {expand})
    @database.execute query, (err, card) =>
      return reply err if err?
      return reply @error.notFound() unless card?
      reply new CardModel(card)

module.exports = GetCardHandler
