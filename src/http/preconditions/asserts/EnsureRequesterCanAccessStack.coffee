_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureRequesterCanAccessStack extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {stack} = request.pre
    {user}  = request.auth.credentials
    @gatekeeper.canUserAccess stack, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden() unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessStack
