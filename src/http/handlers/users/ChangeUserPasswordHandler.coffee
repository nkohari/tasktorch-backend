Handler = require 'http/framework/Handler'
ChangeUserPasswordCommand = require 'data/commands/ChangeUserPasswordCommand'
UserPasswordChangedEvent = require 'data/events/UserPasswordChangedEvent'

class ChangeUserPasswordHandler extends Handler

  @route 'put /api/users/{userId}/password'
  @demand 'requester is user'
  
  constructor: (@database, @eventBus, @passwordHasher) ->

  handle: (request, reply) ->
    {user} = request.scope
    {password} = request.payload
    hashedPassword = @passwordHasher.hash(password)
    command = new ChangeUserPasswordCommand(user.id, hashedPassword)
    @database.execute command, (err) =>
      return callback(err) if err?
      event = new UserPasswordChangedEvent(user)
      @eventBus.publish event, @getRequestMetadata(request), (err) =>
        return reply err if err?
        reply()

module.exports = ChangeUserPasswordHandler
