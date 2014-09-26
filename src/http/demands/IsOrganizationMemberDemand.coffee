Organization = require 'data/entities/Organization'
GetQuery     = require 'data/queries/GetQuery'
Demand       = require '../framework/Demand'

class IsOrganizationMemberDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {organizationId} = request.params
    query = new GetQuery(Organization, organizationId)
    @database.execute query, (err, organization) =>
      return reply(err) if err?
      return reply(@error.notFound()) unless organization?
      request.scope.organization = organization
      user = request.auth.credentials.user
      if organization.members.any((m) -> m.equals(user))
        return reply()
      else
        return reply @error.unauthorized()

module.exports = IsOrganizationMemberDemand
