Precondition = require 'apps/api/framework/Precondition'

class EnsureInviteBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {invite, org} = request.pre
    if not invite? or invite.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureInviteBelongsToOrg
