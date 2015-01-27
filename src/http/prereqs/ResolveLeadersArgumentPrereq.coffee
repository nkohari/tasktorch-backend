Prereq             = require 'http/framework/Prereq'
MultiGetUsersQuery = require 'data/queries/MultiGetUsersQuery'

class ResolveLeadersArgumentPrereq extends Prereq

  constructor: (@database) ->

  execute: (request, reply) ->

    unless request.payload.leaders?.length > 0
      return reply []

    query = new MultiGetUsersQuery(request.payload.leaders)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply(result.users)

module.exports = ResolveLeadersArgumentPrereq
