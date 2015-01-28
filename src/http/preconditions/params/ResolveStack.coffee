Precondition  = require 'http/framework/Precondition'
GetStackQuery = require 'data/queries/stacks/GetStackQuery'

class ResolveStack extends Precondition

  assign: 'stack'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetStackQuery(request.params.stackid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.stack?
      reply(result.stack)

module.exports = ResolveStack
