_ = require 'lodash'

class EventBus

  constructor: (@log, @pusher) ->

  publish: (events...) ->
    # TODO
    _.each _.flatten(events), (event) =>
      {organization} = event.metadata
      return unless organization?
      @log.debug "Sending #{event.type} to channel #{organization.id}"
      @pusher.trigger("presence-#{organization.id}", event.type, event.toJSON(), event.metadata.socketId)

module.exports = EventBus
