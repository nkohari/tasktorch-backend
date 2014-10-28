Schema   = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

Event = Schema.create 'Event',

  table: 'events'

  relations:
    user:         {type: HasOne,  schema: 'User'}
    organization: {type: HasOne,  schema: 'Organization'}

module.exports = Event
