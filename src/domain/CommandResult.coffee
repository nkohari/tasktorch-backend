_                 = require 'lodash'
MessageCollection = require './MessageCollection'
NoteCollection    = require './NoteCollection'

class CommandResult

  constructor: (user) ->
    @messages = new MessageCollection(user)
    @notes    = new NoteCollection(user)

  getMessages: ->
    @messages.toArray()

  getNotes: ->
    @notes.toArray()

module.exports = CommandResult
