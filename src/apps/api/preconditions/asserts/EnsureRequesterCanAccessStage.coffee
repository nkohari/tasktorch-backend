_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterCanAccessStage extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {stage} = request.pre
    {user}  = request.auth.credentials
    @gatekeeper.canUserAccess stage, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access stage #{stage.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessStage
