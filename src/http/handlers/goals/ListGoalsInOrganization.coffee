_ = require 'lodash'
Handler = require 'http/framework/Handler'
GetAllGoalsInOrganizationQuery = require 'data/queries/GetAllGoalsInOrganizationQuery'

class ListGoalsInOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/goals'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {organization} = request.scope
    query = new GetAllGoalsInOrganizationQuery(organization.id, @getQueryOptions(request))
    @database.execute query, (err, goals) =>
      return reply err if err?
      models = _.map goals, (goal) => @modelFactory.create(goal, request)
      reply(models)

module.exports = ListGoalsInOrganizationHandler
