_            = require 'lodash'
Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterCanAccessOrg extends Precondition

  constructor: (@gatekeeper) ->

  execute: (request, reply) ->
    {org}  = request.pre
    {user} = request.auth.credentials
    @gatekeeper.canUserAccess org, user, (err, isAllowed) =>
      return reply err if err?
      return reply @error.forbidden("You do not have permission to access org #{org.id}") unless isAllowed
      return reply()

module.exports = EnsureRequesterCanAccessOrg
