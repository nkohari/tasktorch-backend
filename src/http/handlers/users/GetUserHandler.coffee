UserModel = require '../../models/UserModel'
Handler   = require '../../framework/Handler'

class GetUserHandler extends Handler

  @route 'get /users/{userId}'

  constructor: (log, @userService) ->
    super(log)

  handle: (request, reply) ->
    {userId} = request.params
    @userService.get userId, (err, user) =>
      return reply @error(err) if err?
      return reply @notFound() unless user?
      reply new UserModel(user)

module.exports = GetUserHandler
