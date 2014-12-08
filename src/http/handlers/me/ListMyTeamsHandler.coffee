_        = require 'lodash'
Response = require 'http/framework/Response'
Handler  = require 'http/framework/Handler'
GetAllTeamsByOrganizationAndMemberQuery = require 'data/queries/GetAllTeamsByOrganizationAndMemberQuery'

class ListMyTeamsHandler extends Handler

  @route 'get /api/{organizationId}/me/teams'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {user} = request.auth.credentials
    query = new GetAllTeamsByOrganizationAndMemberQuery(organization.id, user.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListMyTeamsHandler
