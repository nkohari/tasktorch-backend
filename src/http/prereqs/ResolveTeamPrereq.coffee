Prereq       = require 'http/framework/Prereq'
GetTeamQuery = require 'data/queries/GetTeamQuery'

class ResolveTeamPrereq extends Prereq

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetTeamQuery(request.params.teamId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.team?
      reply(result.team)

module.exports = ResolveTeamPrereq
