Handler                  = require 'http/framework/Handler'
GetAllActionsByCardQuery = require 'data/queries/actions/GetAllActionsByCardQuery'

class ListActionsByCardHandler extends Handler

  @route 'get /api/{orgid}/cards/{cardid}/actions'

  @pre [
    'resolve org'
    'resolve card'
    'resolve query options'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {card, options} = request.pre
    query = new GetAllActionsByCardQuery(card.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListActionsByCardHandler
