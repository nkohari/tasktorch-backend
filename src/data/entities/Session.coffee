SessionCreatedEvent = require 'events/sessions/SessionCreatedEvent'
SessionEndedEvent   = require 'events/sessions/SessionEndedEvent'
Entity              = require '../framework/Entity'
User                = require './User'

class Session extends Entity

  @table  'sessions'

  @field  'isActive', Entity.DataType.BOOLEAN
  @hasOne 'user',     User

  onCreated: ->
    @announce new SessionCreatedEvent(this)

  end: ->
    @isActive = false
    @announce new SessionEndedEvent(this)

module.exports = Session
