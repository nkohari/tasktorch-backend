GetGoalQuery = require 'data/queries/GetGoalQuery'
Handler      = require 'http/framework/Handler'
Response     = require 'http/framework/Response'

class GetGoalHandler extends Handler

  @route 'get /api/{orgId}/goals/{goalId}'
  @demand 'requester is org member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {goalId} = request.params
    query    = new GetGoalQuery(goalId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.goal?
      reply new Response(result)

module.exports = GetGoalHandler
