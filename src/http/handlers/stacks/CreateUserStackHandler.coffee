{Stack}    = require 'data/entities'
StackModel = require '../../models/StackModel'
Handler    = require '../../framework/Handler'

class CreateUserStackHandler extends Handler

  @route 'post /api/{organizationId}/users/{userId}/stacks'
  @demand ['requester is organization member', 'requester is user']

  constructor: (@database) ->

  handle: (request, reply) ->

    stack = new Stack
      name: request.payload.name
      organization: request.scope.organization
      owner: request.scope.user

    @database.create stack, (err) =>
      return reply err if err?
      model = new StackModel(request.baseUrl, stack)
      reply(model).location(model.uri)

module.exports = CreateUserStackHandler
