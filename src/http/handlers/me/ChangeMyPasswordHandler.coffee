Handler = require 'http/framework/Handler'
ChangeUserPasswordCommand = require 'data/commands/ChangeUserPasswordCommand'
UserPasswordChangedEvent = require 'data/events/UserPasswordChangedEvent'

class ChangeMyPasswordHandler extends Handler

  @route 'put /api/me/password'
  
  constructor: (@database, @eventBus, @passwordHasher) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    {password} = request.payload
    hashedPassword = @passwordHasher.hash(password)
    command = new ChangeUserPasswordCommand(user.id, hashedPassword, request.expectedVersion)
    @database.execute command, (err) =>
      return reply err if err?
      event = new UserPasswordChangedEvent(user)
      @eventBus.publish event, @getRequestMetadata(request), (err) =>
        return reply err if err?
        reply()

module.exports = ChangeMyPasswordHandler
