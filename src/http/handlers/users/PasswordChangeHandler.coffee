Handler = require '../../framework/Handler'

class PasswordChangeHandler extends Handler

  @route 'post /users/{userId}/passwordChange'
  @demand 'is user'
  
  constructor: (@userService) ->

  handle: (request, reply) ->
    {user}     = request.scope
    {password} = request.payload
    @userService.changePassword user, password, (err) =>
      return reply err if err?
      reply()

module.exports = PasswordChangeHandler
