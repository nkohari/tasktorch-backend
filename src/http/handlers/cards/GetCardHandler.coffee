GetCardQuery = require 'data/queries/GetCardQuery'
Handler      = require 'http/framework/Handler'
Response     = require 'http/framework/Response'

class GetCardHandler extends Handler

  @route  'get /api/{organizationId}/cards/{cardId}'
  @demand 'requester is organization member'

  constructor: (@database) ->

  handle: (request, reply) ->
    {cardId} = request.params
    query    = new GetCardQuery(cardId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.card?
      response = new Response(result)
      reply(response)

module.exports = GetCardHandler
