Prereq        = require 'http/framework/Prereq'
GetStackQuery = require 'data/queries/GetStackQuery'

class ResolveStackPrereq extends Prereq

  constructor: (@database) ->

  execute: (request, reply) ->
    query = new GetStackQuery(request.params.stackId)
    @database.execute query, (err, result) =>
      return reply err if err?
      return reply @error.notFound() unless result.stack?
      reply(result.stack)

module.exports = ResolveStackPrereq
