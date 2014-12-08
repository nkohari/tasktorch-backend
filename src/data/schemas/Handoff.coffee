Schema = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

Handoff = Schema.create 'Handoff',

  table:    'handoffs'
  singular: 'handoff'
  plural:   'handoffs'

  relations:
    card:   {type: HasOne, schema: 'Card'}
    sender: {type: HasOne, schema: 'User'}
    user:   {type: HasOne, schema: 'User'}
    team:   {type: HasOne, schema: 'Team'}

module.exports = Handoff
