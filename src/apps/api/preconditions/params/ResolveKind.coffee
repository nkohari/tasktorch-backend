Precondition = require 'apps/api/framework/Precondition'
GetKindQuery = require 'data/queries/kinds/GetKindQuery'

class ResolveKind extends Precondition

  assign: 'kind'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetKindQuery(request.params.kindid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.kind?
      reply(result.kind)

module.exports = ResolveKind
