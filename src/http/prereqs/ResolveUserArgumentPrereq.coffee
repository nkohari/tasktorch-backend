Prereq       = require 'http/framework/Prereq'
GetUserQuery = require 'data/queries/GetUserQuery'

class ResolveUserArgumentPrereq extends Prereq

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetUserQuery(request.payload.user)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest() unless result.user?
      reply(result.user)

module.exports = ResolveUserArgumentPrereq
