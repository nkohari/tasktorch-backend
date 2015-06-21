Precondition = require 'apps/api/framework/Precondition'

class EnsureStageBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {stage, org} = request.pre
    if not stage? or stage.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureStageBelongsToOrg
