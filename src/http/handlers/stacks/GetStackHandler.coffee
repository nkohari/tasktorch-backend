Stack      = require 'data/entities/Stack'
GetQuery   = require 'data/queries/GetQuery'
StackModel = require '../../models/StackModel'
Handler    = require '../../framework/Handler'

class GetStackHandler extends Handler

  @route 'get /organizations/{organizationId}/stacks/{stackId}'
  @demand ['is organization member', 'is stack participant']

  constructor: (@log, @database) ->

  handle: (request, reply) ->
    {stackId} = request.params
    expand    = request.query.expand?.split(',')
    query     = new GetQuery(Stack, stackId, {expand})
    @database.execute query, (err, stack) =>
      return reply err if err?
      reply new StackModel(request.baseUrl, stack)

module.exports = GetStackHandler
