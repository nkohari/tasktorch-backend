_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterCanAccessCard extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {card} = request.pre
    {user} = request.auth.credentials
    @gatekeeper.canUserAccess card, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access card #{card.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessCard
