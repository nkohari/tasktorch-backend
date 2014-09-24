UserModel = require '../../models/UserModel'
Handler   = require '../../framework/Handler'

class GetUserHandler extends Handler

  @route 'get /users/{userId}'
  @demand 'is user'

  constructor: (@userService) ->

  handle: (request, reply) ->
    {userId} = request.params
    @userService.get userId, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      reply new UserModel(user)

module.exports = GetUserHandler
