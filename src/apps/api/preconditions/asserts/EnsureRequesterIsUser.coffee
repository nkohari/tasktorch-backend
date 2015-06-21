Precondition = require 'apps/api/framework/Precondition'

class EnsureRequesterIsUser extends Precondition

  execute: (request, reply) ->
    requester = request.auth.credentials.user
    {user} = request.pre
    if not user? or user.id == requester.id
      return reply()
    else
      return reply @error.forbidden("You are not the user with id #{user.id}")

module.exports = EnsureRequesterIsUser
