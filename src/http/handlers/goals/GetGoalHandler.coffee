Handler      = require 'http/framework/Handler'
GetGoalQuery = require 'data/queries/goals/GetGoalQuery'

class GetGoalHandler extends Handler

  @route 'get /api/{orgid}/goals/{goalid}'

  @before [
    'resolve org'
    'resolve query options'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->

    {org, options} = request.pre
    {goalid}       = request.params

    query    = new GetGoalQuery(goalid, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.goal?
      return reply @error.notFound() unless result.goal.org == org.id
      reply @response(result)

module.exports = GetGoalHandler
