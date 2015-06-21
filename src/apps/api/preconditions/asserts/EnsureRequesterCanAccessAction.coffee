_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterCanAccessAction extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {action} = request.pre
    {user}   = request.auth.credentials
    @gatekeeper.canUserAccess action, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access action #{action.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessAction
