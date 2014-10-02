_         = require 'lodash'
{Team}    = require 'data/entities'
TeamModel = require '../../models/TeamModel'
Handler   = require '../../framework/Handler'
{GetAllTeamsByOrganizationAndMemberQuery} = require 'data/queries'

class ListMyTeamsHandler extends Handler

  @route 'get /api/{organizationId}/my/teams'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {user} = request.auth.credentials
    expand = request.query.expand?.split(',')
    query = new GetAllTeamsByOrganizationAndMemberQuery(organization, user, {expand})
    @database.execute query, (err, teams) =>
      return reply err if err?
      reply _.map teams, (team) -> new TeamModel(request.baseUrl, team)

module.exports = ListMyTeamsHandler
