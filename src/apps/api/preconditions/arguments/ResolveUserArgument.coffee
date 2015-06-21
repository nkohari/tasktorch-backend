Precondition = require 'apps/api/framework/Precondition'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class ResolveUserArgument extends Precondition

  assign: 'user'

  constructor: (@database) ->

  execute: (request, reply) ->
    userid = request.payload.user
    query = new GetUserQuery(userid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such user #{userid}") unless result.user?
      reply(result.user)

module.exports = ResolveUserArgument
