_                             = require 'lodash'
Handler                       = require 'http/framework/Handler'
GetAllParticipantsOnCardQuery = require 'data/queries/GetAllParticipantsOnCardQuery'

class ListParticipantsOnCardHandler extends Handler

  @route 'get /api/{organizationId}/cards/{cardId}/participants'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {cardId} = request.params
    query = new GetAllParticipantsOnCardQuery(cardId, @getQueryOptions(request))
    @database.execute query, (err, users) =>
      return reply err if err?
      models = _.map users, (user) => @modelFactory.create(user, request)
      reply(models)

module.exports = ListParticipantsOnCardHandler
