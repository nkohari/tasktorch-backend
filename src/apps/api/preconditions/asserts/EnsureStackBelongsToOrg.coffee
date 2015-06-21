Precondition = require 'apps/api/framework/Precondition'

class EnsureStackBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {stack, org} = request.pre
    if not stack? or stack.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureStackBelongsToOrg
