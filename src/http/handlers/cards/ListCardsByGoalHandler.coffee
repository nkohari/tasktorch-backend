Handler                = require 'http/framework/Handler'
GetAllCardsByGoalQuery = require 'data/queries/cards/GetAllCardsByGoalQuery'

class ListCardsByGoalHandler extends Handler

  @route 'get /api/{orgid}/goals/{goalid}/cards'

  @before [
    'resolve org'
    'resolve goal'
    'resolve query options'
    'ensure goal belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {goal, options} = request.pre
    query = new GetAllCardsByGoalQuery(goal.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListCardsByGoalHandler
