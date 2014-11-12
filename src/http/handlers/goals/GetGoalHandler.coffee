GetGoalQuery = require 'data/queries/GetGoalQuery'
Handler      = require 'http/framework/Handler'

class GetGoalHandler extends Handler

  @route 'get /api/{organizationId}/goals/{goalId}'
  @demand 'requester is organization member'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {goalId} = request.params
    query    = new GetGoalQuery(goalId, @getQueryOptions(request))
    @database.execute query, (err, goal) =>
      return reply err if err?
      return reply @error.notFound() unless goal?
      model = @modelFactory.create(goal, request)
      reply(model).etag(model.version)

module.exports = GetGoalHandler
