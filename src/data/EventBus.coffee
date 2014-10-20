_ = require 'lodash'

class EventBus

  constructor: (@log) ->

  publish: (events...) ->
    events = _.flatten(events)
    @log.inspect(events, 999)

module.exports = EventBus
