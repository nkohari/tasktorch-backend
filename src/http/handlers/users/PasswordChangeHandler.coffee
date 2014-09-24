Handler = require '../../framework/Handler'

class PasswordChangeHandler extends Handler

  @route 'post /users/{userId}/passwordChange'
  @demand 'is user'
  
  constructor: (@userService) ->

  handle: (request, reply) ->
    {userId}   = request.params
    {password} = request.payload
    @userService.get userId, (err, user) =>
      return reply err if err?
      return reply @error.notFound() unless user?
      @userService.changePassword user, password, (err) =>
        return reply err if err?
        reply()

module.exports = PasswordChangeHandler
