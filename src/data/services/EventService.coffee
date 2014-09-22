ChangePasswordEvent = require 'events/user/ChangePasswordEvent'
User                = require '../entities/User'
Service             = require '../framework/Service'

class EventService extends Service

  @type Event

module.exports = EventService
