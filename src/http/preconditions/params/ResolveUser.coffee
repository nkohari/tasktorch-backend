Precondition = require 'http/framework/Precondition'
GetUserQuery = require 'data/queries/users/GetUserQuery'

class ResolveUser extends Precondition

  assign: 'user'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetUserQuery(request.params.userid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.user?
      reply(result.user)

module.exports = ResolveUser
