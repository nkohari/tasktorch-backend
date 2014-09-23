class Event

  constructor: ->
    @type = @constructor.name
    @timestamp = new Date()

module.exports = Event
