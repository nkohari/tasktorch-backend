Handler      = require 'http/framework/Handler'
Response     = require 'http/framework/Response'
GetTeamQuery = require 'data/queries/GetTeamQuery'

class GetTeamHandler extends Handler

  @route 'get /api/{orgId}/teams/{teamId}'
  @demand ['requester is org member', 'team belongs to org']

  constructor: (@database) ->

  handle: (request, reply) ->
    {teamId} = request.params
    query = new GetTeamQuery(teamId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetTeamHandler
