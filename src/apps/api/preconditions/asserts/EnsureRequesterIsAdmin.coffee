_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'
UserLevel    = require 'data/enums/UserLevel'

class EnsureRequesterIsAdmin extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {user} = request.auth.credentials

    unless user.level is UserLevel.Admin
      return reply @error.forbidden("You do not have permission to do that.")

    return reply()

module.exports = EnsureRequesterIsAdmin
