class EventBus

  constructor: (@log) ->

  publish: (event) ->
    @log.inspect {event}

module.exports = EventBus
