GetCardQuery = require 'data/queries/GetCardQuery'
Handler      = require 'http/framework/Handler'

class GetCardHandler extends Handler

  @route 'get /api/{organizationId}/cards/{cardId}'
  @demand 'requester is organization member'

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {cardId} = request.params
    query    = new GetCardQuery(cardId, @getQueryOptions(request))
    @database.execute query, (err, card) =>
      return reply err if err?
      return reply @error.notFound() unless card?
      model = @modelFactory.create(card, request)
      reply(model).etag(model.version)

module.exports = GetCardHandler
