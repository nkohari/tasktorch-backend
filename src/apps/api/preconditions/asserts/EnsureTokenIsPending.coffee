Precondition = require 'apps/api/framework/Precondition'
TokenStatus = require 'data/enums/TokenStatus'

class EnsureTokenIsPending extends Precondition

  execute: (request, reply) ->
    {token, org} = request.pre
    if not token? or token.status is TokenStatus.Pending
      return reply()
    else
      return reply @error.badRequest("The token #{token.id} has been deleted or was already accepted")

module.exports = EnsureTokenIsPending
