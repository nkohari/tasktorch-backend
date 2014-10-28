_            = require 'lodash'
GetTeamQuery = require 'data/queries/GetTeamQuery'
Demand       = require '../framework/Demand'

class TeamBelongsToOrganizationDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {organizationId, teamId} = request.params
    query = new GetTeamQuery(teamId)
    @database.execute query, (err, team) =>
      return reply err if err?
      if team.organization == organizationId
        return reply()
      else
        return reply @error.unauthorized()

module.exports = TeamBelongsToOrganizationDemand
