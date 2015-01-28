_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureRequesterIsMemberOfTeam extends Precondition

  execute: (request, reply) ->
    if _.contains(request.pre.team.members, request.auth.credentials.user.id)
      return reply()
    else
      return reply @error.unauthorized()

module.exports = EnsureRequesterIsMemberOfTeam
