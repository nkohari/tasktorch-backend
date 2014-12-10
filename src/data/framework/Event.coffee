_    = require 'lodash'
uuid = require 'common/util/uuid'

class Event

  constructor: (document, user) ->
    @id           = uuid()
    @type         = @constructor.name.replace(/Event$/, '')
    @time         = new Date()
    @document     = document.id
    @documentType = document.getSchema().name
    @user         = user.id
    @version      = 0

module.exports = Event
