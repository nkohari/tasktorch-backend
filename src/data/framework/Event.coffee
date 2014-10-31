_    = require 'lodash'
uuid = require 'common/util/uuid'

class Event

  constructor: ->
    @id        = uuid()
    @type      = @constructor.name.replace(/Event$/, '')
    @timestamp = new Date()

module.exports = Event
