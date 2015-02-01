Precondition  = require 'http/framework/Precondition'
GetStackQuery = require 'data/queries/stacks/GetStackQuery'

class ResolveStackArgument extends Precondition

  assign: 'stack'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetStackQuery(request.payload.stack)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest() unless result.stack?
      reply(result.stack)

module.exports = ResolveStackArgument
