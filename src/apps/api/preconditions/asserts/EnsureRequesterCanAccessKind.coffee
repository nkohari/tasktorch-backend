_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterCanAccessKind extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {kind} = request.pre
    {user} = request.auth.credentials
    @gatekeeper.canUserAccess kind, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access kind #{kind.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessKind
