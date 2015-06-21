Precondition = require 'apps/api/framework/Precondition'
GetTeamQuery = require 'data/queries/teams/GetTeamQuery'

class ResolveTeamByStack extends Precondition

  assign: 'team'

  constructor: (@database) ->

  execute: (request, reply) ->
    {stack} = request.pre
    return reply null unless stack.team?
    query = new GetTeamQuery(stack.team)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply(result.team)

module.exports = ResolveTeamByStack
