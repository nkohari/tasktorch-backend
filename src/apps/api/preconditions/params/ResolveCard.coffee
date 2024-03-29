Precondition = require 'apps/api/framework/Precondition'
GetCardQuery = require 'data/queries/cards/GetCardQuery'

class ResolveCard extends Precondition

  assign: 'card'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetCardQuery(request.params.cardid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.card?
      reply(result.card)

module.exports = ResolveCard
