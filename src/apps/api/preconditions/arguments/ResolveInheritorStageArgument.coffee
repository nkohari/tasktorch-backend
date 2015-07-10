Precondition  = require 'apps/api/framework/Precondition'
GetStageQuery = require 'data/queries/stages/GetStageQuery'

class ResolveInheritorStage extends Precondition

  assign: 'inheritorStage'

  constructor: (@database) ->

  execute: (request, reply) ->
    stageid = request.payload.inheritorStage
    query = new GetStageQuery(stageid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.badRequest("No such stage #{stageid}") unless result.stage?
      reply(result.stage)

module.exports = ResolveInheritorStage
