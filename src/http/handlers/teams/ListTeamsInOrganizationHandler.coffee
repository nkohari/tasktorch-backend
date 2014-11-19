_                              = require 'lodash'
Handler                        = require 'http/framework/Handler'
FindTeamsByOrganizationQuery   = require 'data/queries/FindTeamsByOrganizationQuery'
GetAllTeamsByOrganizationQuery = require 'data/queries/GetAllTeamsByOrganizationQuery'

class ListTeamsInOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/teams'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {organization} = request.scope
    options = @getQueryOptions(request)

    if request.query.suggest?
      query = new FindTeamsByOrganizationQuery(organization.id, request.query.suggest, options)
    else
      query = new GetAllTeamsByOrganizationQuery(organization.id, options)

    @database.execute query, (err, teams) =>
      return reply err if err?
      models = _.map teams, (team) => @modelFactory.create(team, request)
      reply(models)

module.exports = ListTeamsInOrganizationHandler
