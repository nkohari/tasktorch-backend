Precondition   = require 'apps/api/framework/Precondition'
GetActionQuery = require 'data/queries/actions/GetActionQuery'

class ResolveAction extends Precondition

  assign: 'action'

  constructor: (@database) ->

  execute: (request, reply) ->
    {actionid} = request.params
    query = new GetActionQuery(actionid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound("No action found with id #{actionid}") unless result.action?
      reply(result.action)

module.exports = ResolveAction
