Message = require 'messaging/Message'

class NoteMessage extends Message

  getChannels: ->
    ["presence-#{@document.organization}"]

module.exports = NoteMessage
