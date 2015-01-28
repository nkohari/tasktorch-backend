Precondition       = require 'http/framework/Precondition'
MultiGetUsersQuery = require 'data/queries/users/MultiGetUsersQuery'

class ResolveMembersArgument extends Precondition

  assign: 'members'

  constructor: (@database) ->

  execute: (request, reply) ->

    unless request.payload.members?.length > 0
      return reply []

    query = new MultiGetUsersQuery(request.payload.members)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply(result.users)

module.exports = ResolveMembersArgument
