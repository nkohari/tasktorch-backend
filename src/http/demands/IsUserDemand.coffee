Demand = require '../framework/Demand'

class IsUserDemand extends Demand

  execute: (request, reply) ->
    user = request.auth.credentials.user
    request.scope.user = user
    if user? and request.params.userId == user.id
      return reply()
    else
      return reply @error.unauthorized()

module.exports = IsUserDemand
