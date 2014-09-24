SessionCreatedEvent = require 'events/sessions/SessionCreatedEvent'
SessionEndedEvent   = require 'events/sessions/SessionEndedEvent'
Session             = require '../entities/Session'
Service             = require '../framework/Service'

class SessionService extends Service

  @type Session

  create: (data, callback) ->
    session = new Session(data)
    @database.create session, (err) =>
      return callback(err) if err?
      event = new SessionCreatedEvent(session)
      @eventBus.publish(event)
      callback(null, session)

  end: (session, callback) ->
    session.isActive = false
    @database.update session, (err) =>
      return callback(err) if err?
      event = new SessionEndedEvent(session)
      @eventBus.publish(event)
      callback(null, session)

module.exports = SessionService
