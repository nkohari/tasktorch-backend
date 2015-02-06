Handler               = require 'http/framework/Handler'
GetAllGoalsByOrgQuery = require 'data/queries/goals/GetAllGoalsByOrgQuery'

class ListGoalsByOrgHandler extends Handler

  @route 'get /api/{orgid}/goals'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {org, options} = request.pre
    query = new GetAllGoalsByOrgQuery(org.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListGoalsByOrgHandler
