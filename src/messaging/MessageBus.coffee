Message = require 'messaging/Message'

class MessageBus

  constructor: (@log, @databaseWatcher, @pusher) ->

  start: (callback = (->)) ->
    @databaseWatcher.on('create', @onCreate)
    @databaseWatcher.on('update', @onUpdate)
    @databaseWatcher.on('delete', @onDelete)
    callback()

  onCreate: (event) =>
    @publish Message.create('Created', event.document)

  onUpdate: (event) =>
    @publish Message.create('Changed', event.document)

  onDelete: (event) =>
    @publish Message.create('Deleted', event.document)

  publish: (message) =>
    channels = message.getChannels()
    @log.debug "Sending #{message.activity} to channels: [#{channels.join(',')}]"
    @pusher.trigger(channels, message.activity, message)

module.exports = MessageBus
