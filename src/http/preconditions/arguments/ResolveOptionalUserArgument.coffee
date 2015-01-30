Precondition = require 'http/framework/Precondition'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class ResolveOptionalUserArgument extends Precondition

  assign: 'user'

  constructor: (@database) ->

  execute: (request, reply) ->
    return reply(null) unless request.payload?.user?
    query = new GetUserQuery(request.payload.user)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.user?
      reply(result.user)

module.exports = ResolveOptionalUserArgument
