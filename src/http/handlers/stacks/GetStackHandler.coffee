Handler       = require 'http/framework/Handler'
Response      = require 'http/framework/Response'
GetStackQuery = require 'data/queries/GetStackQuery'

class GetStackHandler extends Handler

  @route 'get /api/{orgId}/stacks/{stackId}'
  @demand ['requester is org member']

  constructor: (@database) ->

  handle: (request, reply) ->
    {stackId} = request.params
    query = new GetStackQuery(stackId, @getQueryOptions(request))
    @database.execute query, (err, result) =>
      return reply err if err?
      reply new Response(result)

module.exports = GetStackHandler
