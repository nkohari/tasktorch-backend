# TODO: This is temporary until we get a real job queue set up
class EventBus

  constructor: (@log, @database, @pusher, @searchIndexer) ->

  publish: (event, metadata, callback) ->
    @database.recordEvent event, (err) =>
      return callback(err) if err?
      @searchIndexer.handle event, (err) =>
        return callback(err) if err?
        {organization} = metadata
        return callback() unless organization?
        @log.debug "Sending #{event.type} to channel #{organization.id}"
        @pusher.trigger("presence-#{organization.id}", event.type, event, metadata.socket)
        callback()

module.exports = EventBus
