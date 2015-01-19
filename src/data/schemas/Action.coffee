Schema   = require 'data/Schema'
{HasOne} = require 'data/RelationType'

Action = Schema.create 'Action',

  table:    'actions'
  singular: 'action'
  plural:   'actions'

  relations:
    organization: {type: HasOne, schema: 'Organization'}
    card:         {type: HasOne, schema: 'Card'}
    owner:        {type: HasOne, schema: 'User'}
    stage:        {type: HasOne, schema: 'Stage'}

module.exports = Action
