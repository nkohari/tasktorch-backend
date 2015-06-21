Precondition = require 'apps/api/framework/Precondition'

class EnsureChecklistBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {checklist, org} = request.pre
    if not checklist? or checklist.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureChecklistBelongsToOrg
