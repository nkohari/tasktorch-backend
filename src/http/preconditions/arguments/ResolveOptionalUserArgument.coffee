Precondition = require 'http/framework/Precondition'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class ResolveUserArgument extends Precondition

  assign: 'user'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetUserQuery(request.payload.user)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply(result.user ? null)

module.exports = ResolveUserArgument
