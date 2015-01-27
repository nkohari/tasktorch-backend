Handler                  = require 'http/framework/Handler'
Response                 = require 'http/framework/Response'
GetAllMembersByTeamQuery = require 'data/queries/GetAllMembersByTeamQuery'

class ListUsersInTeamHandler extends Handler

  @route 'get /api/{orgId}/teams/{teamId}/members'
  @demand ['requester is org member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {teamId} = request.params
    query    = new GetAllMembersByTeamQuery(teamId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListUsersInTeamHandler
