_                        = require 'lodash'
GetAllActionsByCardQuery = require 'data/queries/GetAllActionsByCardQuery'
Handler                  = require 'http/framework/Handler'
Response                 = require 'http/framework/Response'

class ListActionsByCardHandler extends Handler

  @route 'get /api/{orgId}/cards/{cardId}/actions'
  @demand ['requester is org member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {cardId} = request.params
    query = new GetAllActionsByCardQuery(cardId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListActionsByCardHandler
