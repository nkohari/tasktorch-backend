Precondition = require 'http/framework/Precondition'
GetCardQuery = require 'data/queries/cards/GetCardQuery'

class ResolveCardArgument extends Precondition

  assign: 'card'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetCardQuery(request.payload.card)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.card?
      reply(result.card)

module.exports = ResolveCardArgument
