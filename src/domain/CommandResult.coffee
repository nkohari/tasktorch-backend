_        = require 'lodash'
Activity = require 'messaging/Activity'
Message  = require 'messaging/Message'

class CommandResult

  constructor: ->
    @_messages = []
    @_events = []

  created: (document) ->
    @_messages.push Message.create(Activity.Created, document)

  changed: (document) ->
    @_messages.push Message.create(Activity.Changed, document)

  deleted: (document) ->
    @_messages.push Message.create(Activity.Deleted, document)

  getMessages: ->
    @_messages

module.exports = CommandResult
