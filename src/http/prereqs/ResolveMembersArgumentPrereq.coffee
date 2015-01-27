Prereq             = require 'http/framework/Prereq'
MultiGetUsersQuery = require 'data/queries/MultiGetUsersQuery'

class ResolveMembersArgumentPrereq extends Prereq

  constructor: (@database) ->

  execute: (request, reply) ->

    unless request.payload.members?.length > 0
      return reply []

    query = new MultiGetUsersQuery(request.payload.members)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply(result.users)

module.exports = ResolveMembersArgumentPrereq
