_ = require 'lodash'

class EventBus

  constructor: (@log, @pusher) ->

  publish: (events...) ->
    # TODO
    _.each _.flatten(events), (event) =>
      return unless event.organizationId
      @log.debug "Sending #{event.type} to channel #{event.organizationId}"
      @pusher.trigger("presence-#{event.organizationId}", event.type, event)

module.exports = EventBus
