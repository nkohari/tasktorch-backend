Precondition  = require 'apps/api/framework/Precondition'
GetTokenQuery = require 'data/queries/tokens/GetTokenQuery'

class ResolveOptionalTokenArgument extends Precondition

  assign: 'token'

  constructor: (@database) ->

  execute: (request, reply) ->
    tokenid = request.payload.token
    return reply(null) unless tokenid?
    query = new GetTokenQuery(tokenid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such token #{tokenid}") unless result.token?
      reply(result.token)

module.exports = ResolveOptionalTokenArgument
