_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureRequesterCanAccessTeam extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {team} = request.pre
    {user} = request.auth.credentials
    @gatekeeper.canUserAccess team, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access team #{team.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessTeam
