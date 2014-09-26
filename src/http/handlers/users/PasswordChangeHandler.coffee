Handler = require '../../framework/Handler'

class PasswordChangeHandler extends Handler

  @route 'post /users/{userId}/passwordChange'
  @demand 'is user'
  
  constructor: (@database, @passwordHasher) ->

  handle: (request, reply) ->
    {user}     = request.scope
    {password} = request.payload
    user.setPassword(@passwordHasher.hash(password))
    @database.update user, (err, user) =>
      return reply err if err?
      reply()

module.exports = PasswordChangeHandler
