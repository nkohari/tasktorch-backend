Precondition = require 'apps/api/framework/Precondition'

class EnsureCardsBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {cards, org} = request.pre
    if not cards? or _.all(cards, (c) -> c.org == org.id)
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureCardsBelongsToOrg
