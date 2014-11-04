_                              = require 'lodash'
Handler                        = require 'http/framework/Handler'
GetAllTeamsByOrganizationQuery = require 'data/queries/GetAllTeamsByOrganizationQuery'

class ListTeamsInOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/teams'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {organization} = request.scope
    query = new GetAllTeamsByOrganizationQuery(organization.id, @getQueryOptions(request))
    @database.execute query, (err, teams) =>
      return reply err if err?
      models = _.map teams, (team) => @modelFactory.create(team, request)
      reply(models)

module.exports = ListTeamsInOrganizationHandler
