Precondition = require 'http/framework/Precondition'
GetTeamQuery = require 'data/queries/teams/GetTeamQuery'

class ResolveOptionalTeamArgument extends Precondition

  assign: 'team'

  constructor: (@database) ->

  execute: (request, reply) ->
    return reply(null) unless request.payload?.team?
    query = new GetTeamQuery(request.payload.team)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.team?
      reply(result.team)

module.exports = ResolveOptionalTeamArgument
