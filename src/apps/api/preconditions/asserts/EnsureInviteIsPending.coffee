Precondition = require 'apps/api/framework/Precondition'
InviteStatus = require 'data/enums/InviteStatus'

class EnsureInviteIsPending extends Precondition

  execute: (request, reply) ->
    {invite, org} = request.pre
    if not invite? or invite.status is InviteStatus.Pending
      return reply()
    else
      return reply @error.badRequest("The invite #{invite.id} has been deleted or was already accepted")

module.exports = EnsureInviteIsPending
