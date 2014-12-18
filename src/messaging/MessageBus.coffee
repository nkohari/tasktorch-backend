class MessageBus

  constructor: (@log, @pusher) ->

  announce: (result, callback) ->
    for message in result.getMessages()
      channels = message.getChannels()
      @log.debug "Sending #{message.activity} to channels: [#{channels.join(',')}]"
      @pusher.trigger(channels, message.activity, message)
    callback()

module.exports = MessageBus
