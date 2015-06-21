Handler                = require 'apps/api/framework/Handler'
GetAllGoalsByCardQuery = require 'data/queries/goals/GetAllGoalsByCardQuery'

class ListGoalsByCardHandler extends Handler

  @route 'get /{orgid}/cards/{cardid}/goals'

  @before [
    'resolve org'
    'resolve card'
    'resolve query options'
    'ensure card belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {card, options} = request.pre
    query = new GetAllGoalsByCardQuery(card.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListGoalsByCardHandler
