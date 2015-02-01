_            = require 'lodash'
Precondition = require 'http/framework/Precondition'

class EnsureRequesterCanAccessOrg extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {org}  = request.pre
    {user} = request.auth.credentials
    @gatekeeper.canUserAccess org, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden() unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessOrg
