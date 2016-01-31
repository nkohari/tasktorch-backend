Precondition = require 'apps/api/framework/Precondition'

class EnsureFileBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {file, org} = request.pre
    if not file? or file.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureFileBelongsToOrg
