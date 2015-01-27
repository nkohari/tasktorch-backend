_                              = require 'lodash'
Response                       = require 'http/framework/Response'
Handler                        = require 'http/framework/Handler'
GetAllTeamsByOrgAndMemberQuery = require 'data/queries/GetAllTeamsByOrgAndMemberQuery'

class ListMyTeamsHandler extends Handler

  @route 'get /api/{orgId}/me/teams'
  @demand 'requester is org member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {org} = request.scope
    {user} = request.auth.credentials
    query = new GetAllTeamsByOrgAndMemberQuery(org.id, user.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListMyTeamsHandler
