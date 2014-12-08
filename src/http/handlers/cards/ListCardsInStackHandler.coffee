_                       = require 'lodash'
GetAllCardsInStackQuery = require 'data/queries/GetAllCardsInStackQuery'
Handler                 = require 'http/framework/Handler'
Response                = require 'http/framework/Response'

class ListCardsInStackHandler extends Handler

  @route 'get /api/{organizationId}/stacks/{stackId}/cards'
  @demand ['requester is organization member', 'requester is stack participant']

  constructor: (@database) ->

  handle: (request, reply) ->
    {stack} = request.scope
    query = new GetAllCardsInStackQuery(stack.id, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListCardsInStackHandler
