Handler               = require 'http/framework/Handler'
ChangeUserNameCommand = require 'data/commands/ChangeUserNameCommand'
UserNameChangedEvent  = require 'data/events/UserNameChangedEvent'

class ChangeMyNameHandler extends Handler

  @route 'put /api/me/name'

  constructor: (@log, @database, @eventBus) ->

  handle: (request, reply) ->
    {user} = request.auth.credentials
    {name} = request.payload
    @log.inspect {user}
    command = new ChangeUserNameCommand(user.id, name, request.expectedVersion)
    @database.execute command, (err) =>
      return reply err if err?
      event = new UserNameChangedEvent(user)
      @eventBus.publish event, @getRequestMetadata(request), (err) =>
        return reply err if err?
        reply()

module.exports = ChangeMyNameHandler
