Handler      = require 'apps/api/framework/Handler'
GetTeamQuery = require 'data/queries/teams/GetTeamQuery'

class GetTeamHandler extends Handler

  @route 'get /{orgid}/teams/{teamid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure org has active subscription'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {teamid}       = request.params

    query = new GetTeamQuery(teamid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.team?
      return reply @error.notFound() unless result.team.org == org.id
      reply @response(result)

module.exports = GetTeamHandler
