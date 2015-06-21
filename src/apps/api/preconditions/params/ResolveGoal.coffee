Precondition = require 'apps/api/framework/Precondition'
GetGoalQuery = require 'data/queries/goals/GetGoalQuery'

class ResolveGoal extends Precondition

  assign: 'goal'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetGoalQuery(request.params.goalid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.goal?
      reply(result.goal)

module.exports = ResolveGoal
