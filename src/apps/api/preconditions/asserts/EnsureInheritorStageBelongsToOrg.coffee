Precondition = require 'apps/api/framework/Precondition'

class EnsureInheritorStageBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {inheritorStage, org} = request.pre
    if not inheritorStage? or inheritorStage.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureInheritorStageBelongsToOrg
