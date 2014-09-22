Handler = require '../../framework/Handler'

class PasswordChangeHandler extends Handler

  @route 'post /users/{userId}/passwordChange'

  constructor: (log, @userService) ->
    super(log)

  handle: (request, reply) ->
    {userId}   = request.params
    {password} = request.payload
    @userService.get userId, (err, user) =>
      return reply @error(err) if err?
      return reply @notFound() unless user?
      @userService.changePassword user, password, (err) =>
        return reply @error(err) if err?
        reply()

module.exports = PasswordChangeHandler
