Precondition = require 'apps/api/framework/Precondition'
GetCardQuery = require 'data/queries/cards/GetCardQuery'

class ResolveOptionalCardsArgument extends Precondition

  assign: 'cards'

  constructor: (@database) ->

  execute: (request, reply) ->

    cards = request.payload.cards
    return reply([]) unless cards?.length > 0

    query = new MultiGetCardsQuery(cards)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply(result.cards)

module.exports = ResolveOptionalCardsArgument
