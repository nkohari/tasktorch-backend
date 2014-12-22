_        = require 'lodash'
Activity = require 'messaging/Activity'
Message  = require 'messaging/Message'

class CommandResult

  constructor: ->
    @_messages = []
    @_events = []

  created: (documents...) ->
    for document in _.flatten(documents)
      @_messages.push Message.create(Activity.Created, document)

  changed: (documents...) ->
    for document in _.flatten(documents)
      @_messages.push Message.create(Activity.Changed, document)

  deleted: (documents...) ->
    for document in _.flatten(documents)
      @_messages.push Message.create(Activity.Deleted, document)

  getMessages: ->
    @_messages

module.exports = CommandResult
