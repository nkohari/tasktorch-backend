Events = require '../events'
Entity = require '../framework/Entity'

class Session extends Entity

  @table  'sessions'

  @field  'isActive', Entity.DataType.BOOLEAN
  @hasOne 'user',     'User'

  onCreated: ->
    @announce new Events.SessionCreatedEvent(this)

  end: ->
    @isActive = false
    @announce new Events.SessionEndedEvent(this)

module.exports = Session
