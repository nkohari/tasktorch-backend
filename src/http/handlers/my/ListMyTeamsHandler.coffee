_ = require 'lodash'
Handler = require 'http/framework/Handler'
GetAllTeamsByOrganizationAndMemberQuery = require 'data/queries/GetAllTeamsByOrganizationAndMemberQuery'

class ListMyTeamsHandler extends Handler

  @route 'get /api/{organizationId}/my/teams'
  @demand 'requester is organization member'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {organization} = request.scope
    {user} = request.auth.credentials
    query = new GetAllTeamsByOrganizationAndMemberQuery(organization.id, user.id, @getQueryOptions(request))
    @database.execute query, (err, teams) =>
      return reply err if err?
      models = _.map teams, (team) => @modelFactory.create(team, request)
      reply(models)

module.exports = ListMyTeamsHandler
