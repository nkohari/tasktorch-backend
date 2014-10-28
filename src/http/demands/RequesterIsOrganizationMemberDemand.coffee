_ = require 'lodash'
GetOrganizationQuery = require 'data/queries/GetOrganizationQuery'
Demand = require '../framework/Demand'

class RequesterIsOrganizationMemberDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {user} = request.auth.credentials
    {organizationId} = request.params
    query = new GetOrganizationQuery(organizationId)
    @database.execute query, (err, organization) =>
      return reply err if err?
      return reply @error.notFound() unless organization?
      request.scope.organization = organization
      if _.contains(organization.members, user.id)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = RequesterIsOrganizationMemberDemand
