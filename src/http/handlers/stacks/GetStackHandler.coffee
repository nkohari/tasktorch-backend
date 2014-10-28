StackModel = require 'http/models/StackModel'
Handler = require 'http/framework/Handler'
GetStackQuery = require 'data/queries/GetStackQuery'

class GetStackHandler extends Handler

  @route 'get /api/{organizationId}/stacks/{stackId}'
  @demand ['requester is organization member', 'requester is stack participant']

  constructor: (@database) ->

  handle: (request, reply) ->
    {stackId} = request.params
    query = new GetStackQuery(stackId, @getQueryOptions(request))
    @database.execute query, (err, stack) =>
      return reply err if err?
      reply new StackModel(stack, request)

module.exports = GetStackHandler
