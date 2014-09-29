_              = require 'lodash'
{Organization} = require 'data/entities'
GetQuery       = require 'data/queries/GetQuery'
Demand         = require '../framework/Demand'

class RequesterIsOrganizationMemberDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {organizationId} = request.params
    query = new GetQuery(Organization, organizationId)
    @database.execute query, (err, organization) =>
      return reply(err) if err?
      return reply(@error.notFound()) unless organization?
      request.scope.organization = organization
      if organization.hasMember(request.auth.credentials.user)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = RequesterIsOrganizationMemberDemand
