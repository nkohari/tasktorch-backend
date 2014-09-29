_              = require 'lodash'
{Organization} = require 'data/entities'
GetQuery       = require 'data/queries/GetQuery'
Demand         = require '../framework/Demand'

class TeamBelongsToOrganizationDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {organizationId, teamId} = request.params
    query = new GetQuery(Organization, organizationId)
    @database.execute query, (err, organization) =>
      return reply err if err?
      if _.any(organization.teams, (t) -> t.id == teamId)
        return reply()
      else
        return reply @error.unauthorized()

module.exports = TeamBelongsToOrganizationDemand
