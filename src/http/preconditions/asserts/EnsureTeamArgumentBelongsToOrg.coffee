Precondition = require 'http/framework/Precondition'

class EnsureTeamArgumentBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {team, org} = request.pre
    if not team? or team.org == org.id
      return reply()
    else
      return reply @error.badRequest("The team #{team.id} is not part of the org #{org.id}")

module.exports = EnsureTeamArgumentBelongsToOrg
