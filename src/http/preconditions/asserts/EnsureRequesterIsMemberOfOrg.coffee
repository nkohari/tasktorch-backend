_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureRequesterIsMemberOfOrg extends Precondition

  execute: (request, reply) ->
    if _.contains(request.pre.org.members, request.auth.credentials.user.id)
      return reply()
    else
      return reply @error.forbidden()

module.exports = EnsureRequesterIsMemberOfOrg
