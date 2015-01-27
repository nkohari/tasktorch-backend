Message = require 'messaging/Message'

class TeamMessage extends Message

  getChannels: ->
    ["presence-#{@document.organization}"]

module.exports = TeamMessage
