_                  = require 'lodash'
MultiGetCardsQuery = require 'data/queries/MultiGetCardsQuery'
CardModel          = require 'http/models/CardModel'
Handler            = require 'http/framework/Handler'

class ListCardsInStackHandler extends Handler

  @route 'get /api/{organizationId}/stacks/{stackId}/cards'
  @demand ['requester is organization member', 'requester is stack participant']

  constructor: (@database) ->

  handle: (request, reply) ->
    {stack} = request.scope
    query = new MultiGetCardsQuery(stack.cards, @getQueryOptions(request))
    @database.execute query, (err, cards) =>
      return reply err if err?
      reply _.map cards, (card) -> new CardModel(card, request)

module.exports = ListCardsInStackHandler
