_               = require 'lodash'
{Card}          = require 'data/entities'
{MultiGetQuery} = require 'data/queries'
CardModel       = require '../../models/CardModel'
Handler         = require '../../framework/Handler'

class ListCardsInStackHandler extends Handler

  @route 'get /{organizationId}/stacks/{stackId}/cards'
  @demand ['requester is organization member', 'requester is stack participant']

  constructor: (@database) ->

  handle: (request, reply) ->
    {stack} = request.scope
    expand = request.query.expand?.split(',')
    query = new MultiGetQuery(Card, _.pluck(stack.cards, 'id'), {expand})
    @database.execute query, (err, cards) =>
      return reply err if err?
      reply _.map cards, (card) -> new CardModel(card)

module.exports = ListCardsInStackHandler
