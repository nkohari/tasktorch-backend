Handler                    = require 'http/framework/Handler'
GetAllFollowersByCardQuery = require 'data/queries/users/GetAllFollowersByCardQuery'

class ListFollowersByCardHandler extends Handler

  @route 'get /api/{orgid}/cards/{cardid}/followers'

  @before [
    'resolve org'
    'resolve card'
    'resolve query options'
    'ensure card belongs to org'
    'ensure requester can access card'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {card, options} = request.pre
    query = new GetAllFollowersByCardQuery(card.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListFollowersByCardHandler
