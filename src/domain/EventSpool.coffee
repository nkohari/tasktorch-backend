CreateEventCommand = require 'domain/commands/events/CreateEventCommand'

class EventSpool

  constructor: (@processor) ->

  write: (event, callback = (->)) ->
    command = new CreateEventCommand(event)
    @processor.execute(command, callback)

module.exports = EventSpool
