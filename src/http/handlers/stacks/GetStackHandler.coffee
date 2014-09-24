StackModel = require '../../models/StackModel'
Handler    = require '../../framework/Handler'

class GetStackHandler extends Handler

  @route 'get /organizations/{organizationId}/stacks/{stackId}'
  @demand ['is organization member', 'is stack participant']

  constructor: (@stackService) ->

  handle: (request, reply) ->
    {stackId} = request.params
    expand    = request.query.expand.split(',') if request.query.expand?.length > 0
    @stackService.get stackId, {expand}, (err, stack) =>
      return reply err if err?
      return reply @error.notFound() unless stack?
      reply new StackModel(request.baseUrl, stack)

module.exports = GetStackHandler
