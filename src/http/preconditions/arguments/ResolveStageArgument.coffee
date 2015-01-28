Precondition  = require 'http/framework/Precondition'
GetStageQuery = require 'data/queries/stages/GetStageQuery'

class ResolveStageArgument extends Precondition

  assign: 'stage'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetStageQuery(request.payload.stage)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.stage?
      reply(result.stage)

module.exports = ResolveStageArgument
