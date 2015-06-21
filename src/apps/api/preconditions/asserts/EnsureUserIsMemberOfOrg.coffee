_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureUserIsMemberOfOrg extends Precondition

  execute: (request, reply) ->
    {org, user} = request.pre
    if not user? or org.hasMember(user.id)
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureUserIsMemberOfOrg
