Precondition = require 'http/framework/Precondition'

class EnsureTeamBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {team, org} = request.pre
    if not team? or team.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureTeamBelongsToOrg
