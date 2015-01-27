Message = require 'messaging/Message'

class StackMessage extends Message

  getChannels: ->
    ["presence-#{@document.org}"]

module.exports = StackMessage
