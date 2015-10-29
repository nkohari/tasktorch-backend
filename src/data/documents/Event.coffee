Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Event extends Document

  @table  'events'
  @naming {singular: 'event', plural: 'events'}

  @field  'id'
  @field  'created'
  @field  'type'

  @hasOne 'user',   {type: 'User'}
  @hasOne 'org',    {type: 'Org'}

module.exports = Event
