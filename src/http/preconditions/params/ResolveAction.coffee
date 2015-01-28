Precondition   = require 'http/framework/Precondition'
GetActionQuery = require 'data/queries/actions/GetActionQuery'

class ResolveAction extends Precondition

  assign: 'action'

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetActionQuery(request.params.actionid)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.action?
      reply(result.action)

module.exports = ResolveAction
