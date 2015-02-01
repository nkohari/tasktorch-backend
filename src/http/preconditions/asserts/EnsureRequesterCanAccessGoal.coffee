_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureRequesterCanAccessGoal extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {goal} = request.pre
    {user} = request.auth.credentials
    @gatekeeper.canUserAccess goal, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden() unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessGoal
