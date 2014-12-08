Handler                  = require 'http/framework/Handler'
Response                 = require 'http/framework/Response'
GetAllMembersOfTeamQuery = require 'data/queries/GetAllMembersOfTeamQuery'

class ListUsersInTeamHandler extends Handler

  @route 'get /api/{organizationId}/teams/{teamId}/members'
  @demand ['requester is organization member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {teamId} = request.params
    query    = new GetAllMembersOfTeamQuery(teamId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListUsersInTeamHandler
