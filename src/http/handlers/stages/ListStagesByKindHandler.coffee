Handler                 = require 'http/framework/Handler'
Response                = require 'http/framework/Response'
GetAllStagesByKindQuery = require 'data/queries/GetAllStagesByKindQuery'

class ListStagesByKindHandler extends Handler

  @route 'get /api/{orgId}/kinds/{kindId}/stages'
  @demand ['requester is org member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {kindId} = request.params
    query = new GetAllStagesByKindQuery(kindId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = ListStagesByKindHandler
