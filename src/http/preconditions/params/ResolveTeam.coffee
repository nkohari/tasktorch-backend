Precondition = require 'http/framework/Precondition'
GetTeamQuery = require 'data/queries/teams/GetTeamQuery'

class ResolveTeam extends Precondition

  assign: 'team'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetTeamQuery(request.params.teamid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.team?
      reply(result.team)

module.exports = ResolveTeam
