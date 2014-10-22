Pusher = require 'pusher'

class PusherClient

  constructor: (@config) ->
    @client = new Pusher(@config.pusher)

  getAuthToken: (socketId, channel, presenceInfo) ->
    @client.authenticate(socketId, channel, presenceInfo)

  trigger: (channels, name, message) ->
    @client.trigger(channels, name, message)

module.exports = PusherClient
