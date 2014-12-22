_                    = require 'lodash'
GetOrganizationQuery = require 'data/queries/GetOrganizationQuery'
Demand               = require '../framework/Demand'

class UserIsMemberOfOrganizationDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {organizationId, userId} = request.params
    query = new GetOrganizationQuery(organizationId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.organization?
      if _.contains(result.organization.members, userId)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = UserIsMemberOfOrganizationDemand
