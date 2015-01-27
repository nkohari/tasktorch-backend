Schema            = require 'data/Schema'
{HasOne, HasMany} = require 'data/RelationType'

Stack = Schema.create 'Stack',

  table:    'stacks'
  singular: 'stack'
  plural:   'stacks'

  relations:
    org:   {type: HasOne,  schema: 'Org'}
    user:  {type: HasOne,  schema: 'User'}
    team:  {type: HasOne,  schema: 'Team'}
    cards: {type: HasMany, schema: 'Card'}

module.exports = Stack
