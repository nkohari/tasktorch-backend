Precondition = require 'apps/api/framework/Precondition'

class EnsureMembershipBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {membership, org} = request.pre
    if not membership? or membership.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureMembershipBelongsToOrg
