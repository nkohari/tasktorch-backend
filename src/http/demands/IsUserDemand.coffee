Demand = require '../framework/Demand'

class IsUserDemand extends Demand

  satisfies: (request, callback) ->
    user = request.auth.credentials.user
    satisfied = user? and request.params.userId == user.id
    callback(null, satisfied)

module.exports = IsUserDemand
