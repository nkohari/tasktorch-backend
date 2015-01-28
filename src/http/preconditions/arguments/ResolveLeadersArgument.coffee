Precondition       = require 'http/framework/Precondition'
MultiGetUsersQuery = require 'data/queries/users/MultiGetUsersQuery'

class ResolveLeadersArgument extends Precondition

  assign: 'leaders'

  constructor: (@database) ->

  execute: (request, reply) ->

    unless request.payload.leaders?.length > 0
      return reply []

    query = new MultiGetUsersQuery(request.payload.leaders)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply(result.users)

module.exports = ResolveLeadersArgument
