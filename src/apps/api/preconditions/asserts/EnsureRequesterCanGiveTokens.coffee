_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'
GrantType    = require 'data/enums/GrantType'

class EnsureRequesterCanGiveTokens extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {user} = request.auth.credentials

    unless _.contains(user.grants, GrantType.GiveTokens)
      return reply @error.forbidden("You do not have permission to do that.")

    return reply()

module.exports = EnsureRequesterCanGiveTokens
