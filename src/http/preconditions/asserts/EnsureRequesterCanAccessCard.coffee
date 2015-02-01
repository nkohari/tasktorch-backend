_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureRequesterCanAccessCard extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {card} = request.pre
    {user} = request.auth.credentials
    @gatekeeper.canUserAccess card, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden() unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessCard
