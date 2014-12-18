Schema            = require 'data/Schema'
{HasOne, HasMany} = require 'data/RelationType'

Stack = Schema.create 'Stack',

  table:    'stacks'
  singular: 'stack'
  plural:   'stacks'

  relations:
    organization: {type: HasOne,  schema: 'Organization'}
    owner:        {type: HasOne,  schema: 'User'}
    team:         {type: HasOne,  schema: 'Team'}
    cards:        {type: HasMany, schema: 'Card'}

module.exports = Stack
