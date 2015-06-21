Precondition = require 'apps/api/framework/Precondition'

class EnsureGoalBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {goal, org} = request.pre
    if not goal? or goal.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureGoalBelongsToOrg
