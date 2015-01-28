Handler      = require 'http/framework/Handler'
GetTeamQuery = require 'data/queries/teams/GetTeamQuery'

class GetTeamHandler extends Handler

  @route 'get /api/{orgid}/teams/{teamid}'

  @pre [
    'resolve org'
    'resolve query options'
    'ensure requester is member of org'
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
