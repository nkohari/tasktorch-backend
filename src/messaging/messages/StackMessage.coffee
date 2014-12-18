Message = require 'messaging/Message'

class StackMessage extends Message

  getChannels: ->
    ["presence-#{@document.organization}"]

module.exports = StackMessage
