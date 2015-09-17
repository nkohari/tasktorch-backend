_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'
UserFlag     = require 'data/enums/UserFlag'

class EnsureRequesterCanGiveTokens extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {user} = request.auth.credentials

    unless _.contains(user.flags, UserFlag.CanGiveTokens)
      return reply @error.forbidden("You do not have permission to do that.")

    return reply()

module.exports = EnsureRequesterCanGiveTokens
