{Stack}    = require 'data/entities'
{GetQuery} = require 'data/queries'
StackModel = require '../../models/StackModel'
Handler    = require '../../framework/Handler'

class GetStackHandler extends Handler

  @route 'get /api/{organizationId}/stacks/{stackId}'
  @demand ['requester is organization member', 'requester is stack participant']

  constructor: (@database) ->

  handle: (request, reply) ->
    {stackId} = request.params
    expand    = request.query.expand?.split(',')
    query     = new GetQuery(Stack, stackId, {expand})
    @database.execute query, (err, stack) =>
      return reply err if err?
      reply new StackModel(stack, request)

module.exports = GetStackHandler
