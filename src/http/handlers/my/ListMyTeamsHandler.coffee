_ = require 'lodash'
TeamModel = require 'http/models/TeamModel'
Handler = require 'http/framework/Handler'
GetAllTeamsByOrganizationAndMemberQuery = require 'data/queries/GetAllTeamsByOrganizationAndMemberQuery'

class ListMyTeamsHandler extends Handler

  @route 'get /api/{organizationId}/my/teams'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {user} = request.auth.credentials
    query = new GetAllTeamsByOrganizationAndMemberQuery(organization.id, user.id, @getQueryOptions(request))
    @database.execute query, (err, teams) =>
      return reply err if err?
      reply _.map teams, (team) -> new TeamModel(team, request)

module.exports = ListMyTeamsHandler
