_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterCanAccessChecklist extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {checklist} = request.pre
    {user}      = request.auth.credentials
    @gatekeeper.canUserAccess checklist, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access checklist #{checklist.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessChecklist
