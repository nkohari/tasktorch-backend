_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureUserIsLeaderOfOrg extends Precondition

  execute: (request, reply) ->
    {org, user} = request.pre
    if not user? or org.hasLeader(user.id)
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureUserIsLeaderOfOrg
