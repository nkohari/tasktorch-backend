Precondition = require 'http/framework/Precondition'

class EnsureKindBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {kind, org} = request.pre
    if not kind? or kind.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureKindBelongsToOrg
