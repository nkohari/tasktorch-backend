Precondition = require 'http/framework/Precondition'

class EnsureActionBelongsToOrg extends Precondition

  execute: (request, reply) ->
    {action, org} = request.pre
    if not action? or action.org == org.id
      return reply()
    else
      return reply @error.notFound()

module.exports = EnsureActionBelongsToOrg
