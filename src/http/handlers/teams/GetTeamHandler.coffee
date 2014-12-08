Handler      = require 'http/framework/Handler'
Response     = require 'http/framework/Response'
GetTeamQuery = require 'data/queries/GetTeamQuery'

class GetTeamHandler extends Handler

  @route 'get /api/{organizationId}/teams/{teamId}'
  @demand ['requester is organization member', 'team belongs to organization']

  constructor: (@database) ->

  handle: (request, reply) ->
    {teamId} = request.params
    query = new GetTeamQuery(teamId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetTeamHandler
