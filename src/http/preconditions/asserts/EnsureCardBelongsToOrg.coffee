Precondition = require 'http/framework/Precondition'

class EnsureCardBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {card, org} = request.pre
    if not card? or card.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureCardBelongsToOrg
