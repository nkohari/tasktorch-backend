_                     = require 'lodash'
GetAllGoalsByOrgQuery = require 'data/queries/GetAllGoalsByOrgQuery'
Handler               = require 'http/framework/Handler'
Response              = require 'http/framework/Response'

class ListGoalsByOrgHandler extends Handler

  @route 'get /api/{orgId}/goals'
  @demand ['requester is org member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {org} = request.scope
    query = new GetAllGoalsByOrgQuery(org.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListGoalsByOrgHandler
