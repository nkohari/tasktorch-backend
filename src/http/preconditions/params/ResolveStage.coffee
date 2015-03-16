Precondition  = require 'http/framework/Precondition'
GetStageQuery = require 'data/queries/stages/GetStageQuery'

class ResolveStage extends Precondition

  assign: 'stage'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetStageQuery(request.params.stageid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.stage?
      reply(result.stage)

module.exports = ResolveStage
