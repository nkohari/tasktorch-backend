Message = require 'messaging/Message'

class CardMessage extends Message

  getChannels: ->
    ["presence-#{@document.organization}"]

module.exports = CardMessage
