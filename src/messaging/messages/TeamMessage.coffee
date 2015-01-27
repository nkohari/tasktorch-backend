Message = require 'messaging/Message'

class TeamMessage extends Message

  getChannels: ->
    ["presence-#{@document.org}"]

module.exports = TeamMessage
