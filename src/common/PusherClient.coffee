Pusher = require 'pusher'

class PusherClient

  constructor: (@config) ->
    @client = new Pusher(@config.pusher)

  getAuthToken: (socket, channel, presenceInfo) ->
    @client.authenticate(socket, channel, presenceInfo)

  trigger: (channels, name, message) ->
    @client.trigger(channels, name, message)

module.exports = PusherClient
