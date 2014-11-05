_                       = require 'lodash'
GetAllCardsInStackQuery = require 'data/queries/GetAllCardsInStackQuery'
Handler                 = require 'http/framework/Handler'

class ListCardsInStackHandler extends Handler

  @route 'get /api/{organizationId}/stacks/{stackId}/cards'
  @demand ['requester is organization member', 'requester is stack participant']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {stack} = request.scope
    query = new GetAllCardsInStackQuery(stack.id, @getQueryOptions(request))
    @database.execute query, (err, cards) =>
      return reply err if err?
      models = _.map cards, (card) => @modelFactory.create(card, request)
      reply(models)

module.exports = ListCardsInStackHandler
