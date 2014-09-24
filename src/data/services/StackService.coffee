StackCreatedEvent = require 'events/stacks/StackCreatedEvent'
Stack             = require '../entities/Stack'
Service           = require '../framework/Service'

class StackService extends Service

  @type Stack

  create: (data, callback) ->
    stack = new Stack(data)
    @database.create stack, (err) =>
      return callback(err) if err?
      event = new StackCreatedEvent(stack)
      @eventBus.publish(event)
      callback(null, stack)

module.exports = StackService
