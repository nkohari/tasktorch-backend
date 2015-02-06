Handler                 = require 'http/framework/Handler'
GetAllStagesByKindQuery = require 'data/queries/stages/GetAllStagesByKindQuery'

class ListStagesByKindHandler extends Handler

  @route 'get /api/{orgid}/kinds/{kindid}/stages'

  @before [
    'resolve org'
    'resolve kind'
    'resolve query options'
    'ensure kind belongs to org'
    'ensure requester can access org'
  ]

  constructor: (@database) ->

  handle: (request, reply) ->
    {kind, options} = request.pre
    query = new GetAllStagesByKindQuery(kind.id, options)
    @database.execute query, (err, result) =>
      return reply err if err?
      reply @response(result)

module.exports = ListStagesByKindHandler
