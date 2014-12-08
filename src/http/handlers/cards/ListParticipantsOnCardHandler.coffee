_                             = require 'lodash'
GetAllParticipantsOnCardQuery = require 'data/queries/GetAllParticipantsOnCardQuery'
Handler                       = require 'http/framework/Handler'
Response                      = require 'http/framework/Response'

class ListParticipantsOnCardHandler extends Handler

  @route 'get /api/{organizationId}/cards/{cardId}/participants'
  @demand ['requester is organization member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {cardId} = request.params
    query = new GetAllParticipantsOnCardQuery(cardId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListParticipantsOnCardHandler
