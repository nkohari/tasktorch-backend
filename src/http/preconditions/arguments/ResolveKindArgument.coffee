Precondition = require 'http/framework/Precondition'
GetKindQuery = require 'data/queries/kinds/GetKindQuery'

class ResolveKindArgument extends Precondition

  assign: 'kind'

  constructor: (@database) ->

  execute: (request, reply) ->
    kindid = request.payload.kind
    query = new GetKindQuery(kindid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such kind #{kindid}") unless result.kind?
      reply(result.kind)

module.exports = ResolveKindArgument
