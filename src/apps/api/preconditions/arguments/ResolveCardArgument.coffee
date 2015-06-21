Precondition = require 'apps/api/framework/Precondition'
GetCardQuery = require 'data/queries/cards/GetCardQuery'

class ResolveCardArgument extends Precondition

  assign: 'card'

  constructor: (@database) ->

  execute: (request, reply) ->
    cardid = request.payload.card
    query = new GetCardQuery(cardid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such card #{cardid}") unless result.card?
      reply(result.card)

module.exports = ResolveCardArgument
