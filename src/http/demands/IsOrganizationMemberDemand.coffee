Demand = require '../framework/Demand'

class IsOrganizationMemberDemand extends Demand

  constructor: (@organizationService) ->

  satisfies: (request, callback) ->
    {organizationId} = request.params
    @organizationService.get organizationId, (err, organization) =>
      return callback(err) if err?
      user = request.auth.credentials.user
      satisfied = user? and organization.users.any (u) -> u.equals(user)
      callback(null, satisfied)

module.exports = IsOrganizationMemberDemand
