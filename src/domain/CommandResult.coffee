_                 = require 'lodash'
MessageCollection = require './MessageCollection'

class CommandResult

  constructor: (user) ->
    @messages = new MessageCollection(user)
    @notes = []

  getMessages: ->
    @messages.toArray()

  addNote: (note) ->
    @notes.push(note)

  getNotes: ->
    @notes

module.exports = CommandResult
