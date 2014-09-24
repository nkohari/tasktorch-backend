StackModel = require '../../models/StackModel'
Handler    = require '../../framework/Handler'

class CreateUserStackHandler extends Handler

  @route 'post /organizations/{organizationId}/users/{userId}/stacks'
  @demand ['is organization member', 'is user']

  constructor: (@stackService) ->

  handle: (request, reply) ->
    data =
      name: request.payload.name
      organization: request.scope.organization
      owner: request.scope.user
    @stackService.create data, (err, stack) =>
      return reply err if err?
      model = new StackModel(request.baseUrl, stack)
      reply(model).location(model.uri)

module.exports = CreateUserStackHandler
