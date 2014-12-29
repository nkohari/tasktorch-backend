_                              = require 'lodash'
GetAllGoalsByOrganizationQuery = require 'data/queries/GetAllGoalsByOrganizationQuery'
Handler                        = require 'http/framework/Handler'
Response                       = require 'http/framework/Response'

class ListGoalsInOrganizationHandler extends Handler

  @route 'get /api/{organizationId}/goals'
  @demand ['requester is organization member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {organization} = request.scope
    query = new GetAllGoalsByOrganizationQuery(organization.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListGoalsInOrganizationHandler
