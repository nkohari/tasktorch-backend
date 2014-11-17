_                       = require 'lodash'
GetAllStagesByKindQuery = require 'data/queries/GetAllStagesByKindQuery'
Handler                 = require 'http/framework/Handler'

class ListStagesByKindHandler extends Handler

  @route 'get /api/{organizationId}/kinds/{kindId}/stages'
  @demand ['requester is organization member']

  constructor: (@database, @modelFactory) ->

  handle: (request, reply) ->
    {kindId} = request.params
    query = new GetAllStagesByKindQuery(kindId, @getQueryOptions(request))
    @database.execute query, (err, stages) =>
      return reply err if err?
      models = _.map stages, (stage) => @modelFactory.create(stage, request)
      reply(models)

module.exports = ListStagesByKindHandler
