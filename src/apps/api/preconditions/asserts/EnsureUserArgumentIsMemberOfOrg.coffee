_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureUserArgumentIsMemberOfOrg extends Precondition

  execute: (request, reply) ->
    {org, user} = request.pre
    if not user? or org.hasMember(user.id)
      return reply()
    else
      return reply @error.badRequest("The user #{user.id} is not a member of the org #{org.id}")

module.exports = EnsureUserArgumentIsMemberOfOrg
