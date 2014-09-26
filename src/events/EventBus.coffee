_ = require 'lodash'

class EventBus

  constructor: (@log) ->

  publish: (events...) ->
    events = _.flatten(events)
    @log.inspect {events}

module.exports = EventBus
