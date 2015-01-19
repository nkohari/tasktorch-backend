Message = require 'messaging/Message'

class ActionMessage extends Message

  getChannels: ->
    ["presence-#{@document.organization}"]

module.exports = ActionMessage
