class Event

  constructor: (@userId) ->
    @type = @constructor.name.replace(/Event$/, '')
    @timestamp = new Date()

module.exports = Event
