Pusher = require 'pusher'

class PusherClient

  constructor: (@config) ->
    @client = new Pusher(@config.pusher)

  getAuthToken: (socketId, channel, presenceInfo) ->
    @client.authenticate(socketId, channel, presenceInfo)

module.exports = PusherClient
