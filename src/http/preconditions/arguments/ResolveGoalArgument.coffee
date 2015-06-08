Precondition = require 'http/framework/Precondition'
GetGoalQuery = require 'data/queries/goals/GetGoalQuery'

class ResolveGoalArgument extends Precondition

  assign: 'goal'

  constructor: (@database) ->

  execute: (request, reply) ->
    goalid = request.payload.goal
    query = new GetGoalQuery(goalid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such goal #{goalid}") unless result.goal?
      reply(result.goal)

module.exports = ResolveGoalArgument
