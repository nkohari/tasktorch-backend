_        = require 'lodash'
Activity = require 'messaging/Activity'
Message  = require 'messaging/Message'

class MessageCollection

  constructor: ->
    @_messages = []

  created: (documents...) ->
    for document in _.flatten(documents)
      @_messages.push Message.create(Activity.Created, document)

  changed: (documents...) ->
    for document in _.flatten(documents)
      @_messages.push Message.create(Activity.Changed, document)

  deleted: (documents...) ->
    for document in _.flatten(documents)
      @_messages.push Message.create(Activity.Deleted, document)

  toArray: ->
    _.clone(@_messages)

module.exports = MessageCollection
