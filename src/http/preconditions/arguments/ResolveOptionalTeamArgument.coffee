Precondition = require 'http/framework/Precondition'
GetTeamQuery = require 'data/queries/teams/GetTeamQuery'

class ResolveTeamArgument extends Precondition

  assign: 'team'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetTeamQuery(request.payload.team)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply(result.team ? null)

module.exports = ResolveTeamArgument
