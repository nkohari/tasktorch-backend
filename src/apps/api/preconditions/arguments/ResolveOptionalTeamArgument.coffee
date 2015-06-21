Precondition = require 'apps/api/framework/Precondition'
GetTeamQuery = require 'data/queries/teams/GetTeamQuery'

class ResolveOptionalTeamArgument extends Precondition

  assign: 'team'

  constructor: (@database) ->

  execute: (request, reply) ->
    teamid = request.payload.team
    return reply(null) unless teamid?
    query = new GetTeamQuery(teamid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such team #{teamid}") unless result.team?
      reply(result.team)

module.exports = ResolveOptionalTeamArgument
