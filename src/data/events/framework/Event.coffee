_ = require 'lodash'

class Event

  constructor: (entity, @metadata) ->
    @id        = entity.id
    @version   = entity.version
    @type      = @constructor.name.replace(/Event$/, '')
    @timestamp = new Date()
    @user      = @metadata.user.id

  toJSON: ->
    _.omit(this, _.functions(this), 'metadata')

module.exports = Event
