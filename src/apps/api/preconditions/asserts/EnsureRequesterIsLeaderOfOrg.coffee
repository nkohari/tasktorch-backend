_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterIsLeaderOfOrg extends Precondition

  execute: (request, reply) ->
    {org}  = request.pre
    {user} = request.auth.credentials
    if org.hasLeader(user.id)
      return reply()
    else
      return reply @error.forbidden("You are not a leader of org #{org.id}")

module.exports = EnsureRequesterIsLeaderOfOrg
