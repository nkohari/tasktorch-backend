_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterCanAccessStack extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {stack} = request.pre
    {user}  = request.auth.credentials
    @gatekeeper.canUserAccess stack, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access stack #{stack.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessStack
