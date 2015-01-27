Prereq       = require 'http/framework/Prereq'
GetUserQuery = require 'data/queries/GetUserQuery'

class ResolveUserPrereq extends Prereq

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetUserQuery(request.params.userId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest() unless result.user?
      reply(result.user)

module.exports = ResolveUserPrereq
