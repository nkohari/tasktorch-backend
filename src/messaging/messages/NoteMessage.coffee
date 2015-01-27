Message = require 'messaging/Message'

class NoteMessage extends Message

  getChannels: ->
    ["presence-#{@document.org}"]

module.exports = NoteMessage
