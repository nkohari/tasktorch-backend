_ = require 'lodash'
GetOrganizationQuery = require 'data/queries/GetOrganizationQuery'
Demand = require '../framework/Demand'

class RequesterIsOrganizationMemberDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {user} = request.auth.credentials
    {organizationId} = request.params
    query = new GetOrganizationQuery(organizationId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.organization?
      request.scope.organization = result.organization
      if _.contains(result.organization.members, user.id)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = RequesterIsOrganizationMemberDemand
