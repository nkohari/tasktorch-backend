_                       = require 'lodash'
GetAllCardsByStageQuery = require 'data/queries/cards/GetAllCardsByStageQuery'
Handler                 = require 'http/framework/Handler'

class ListCardsByStageHandler extends Handler

  @route 'get /api/{orgid}/stages/{stageid}/cards'

  @before [
    'resolve org'
    'resolve stage'
    'resolve query options'
    'ensure stage belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {stage, options} = request.pre
    query = new GetAllCardsByStageQuery(stage.id, stage.kind, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @response(result)

module.exports = ListCardsByStageHandler
