_             = require 'lodash'
EventDocument = require 'data/documents/Event'

class Event

  constructor: (@userid, @orgid) ->
    @type = @constructor.name.replace(/Event$/, '')

  createDocument: ->
    return new EventDocument {
      type: @type
      user: @userid
      org:  @orgid
    }

module.exports = Event
