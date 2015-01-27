_            = require 'lodash'
GetTeamQuery = require 'data/queries/GetTeamQuery'
Demand       = require '../framework/Demand'

class TeamBelongsToOrgDemand extends Demand

  constructor: (@database) ->

  execute: (request, reply) ->
    {orgId, teamId} = request.params
    query = new GetTeamQuery(teamId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.team?
      if result.team.org == orgId
        return reply()
      else
        return reply @error.unauthorized()

module.exports = TeamBelongsToOrgDemand
