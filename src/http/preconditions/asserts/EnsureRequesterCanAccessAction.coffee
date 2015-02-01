_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureRequesterCanAccessAction extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {action} = request.pre
    {user}   = request.auth.credentials
    @gatekeeper.canUserAccess action, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden() unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessAction
