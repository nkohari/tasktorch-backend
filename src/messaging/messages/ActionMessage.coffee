Message = require 'messaging/Message'

class ActionMessage extends Message

  getChannels: ->
    ["presence-#{@document.org}"]

module.exports = ActionMessage
