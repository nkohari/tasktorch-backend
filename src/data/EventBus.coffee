class EventBus

  constructor: (@log, @database, @pusher) ->

  publish: (event, metadata, callback) ->
    @database.recordEvent event, (err) =>
      return callback(err) if err?
      {organization} = metadata
      return callback() unless organization?
      @log.debug "Sending #{event.type} to channel #{organization.id}"
      @pusher.trigger("presence-#{organization.id}", event.type, event, metadata.socket)
      callback()

module.exports = EventBus
