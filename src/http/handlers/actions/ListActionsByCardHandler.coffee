_                        = require 'lodash'
GetAllActionsByCardQuery = require 'data/queries/GetAllActionsByCardQuery'
Handler                  = require 'http/framework/Handler'

class ListActionsByCardHandler extends Handler

  @route 'get /api/{organizationId}/cards/{cardId}/actions'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {cardId} = request.params
    query = new GetAllActionsByCardQuery(cardId, @getQueryOptions(request))
    @database.execute query, (err, actions) =>
      return reply err if err?
      models = _.map actions, (action) => @modelFactory.create(action, request)
      reply(models)

module.exports = ListActionsByCardHandler
