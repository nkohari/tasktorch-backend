Precondition  = require 'apps/api/framework/Precondition'
GetStackQuery = require 'data/queries/stacks/GetStackQuery'

class ResolveOptionalStackArgument extends Precondition

  assign: 'stack'

  constructor: (@database) ->

  execute: (request, reply) ->
    stackid = request.payload.stack
    return reply(null) unless stackid?
    query = new GetStackQuery(stackid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such stack #{stackid}") unless result.stack?
      reply(result.stack)

module.exports = ResolveOptionalStackArgument
