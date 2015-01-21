_                          = require 'lodash'
GetAllFollowersByCardQuery = require 'data/queries/GetAllFollowersByCardQuery'
Handler                    = require 'http/framework/Handler'
Response                   = require 'http/framework/Response'

class ListFollowersByCardHandler extends Handler

  @route 'get /api/{organizationId}/cards/{cardId}/followers'
  @demand ['requester is organization member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {cardId} = request.params
    query = new GetAllFollowersByCardQuery(cardId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListFollowersByCardHandler
