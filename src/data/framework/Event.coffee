_    = require 'lodash'
uuid = require 'common/uuid'

class Event

  constructor: ->
    @id        = uuid.generate()
    @type      = @constructor.name.replace(/Event$/, '')
    @timestamp = new Date()

module.exports = Event
