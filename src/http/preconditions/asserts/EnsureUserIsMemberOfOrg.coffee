_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureUserIsMemberOfOrg extends Precondition

  execute: (request, reply) ->
    {org, user} = request.pre
    if not user? or _.contains(org.members, user.id)
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureUserIsMemberOfOrg
