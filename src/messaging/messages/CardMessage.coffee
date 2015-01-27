Message = require 'messaging/Message'

class CardMessage extends Message

  getChannels: ->
    ["presence-#{@document.org}"]

module.exports = CardMessage
