Schema = require 'data/Schema'
{HasOne, HasMany, HasManyForeign} = require 'data/RelationType'

Card = Schema.create 'Card',

  table:    'cards'
  singular: 'card'
  plural:   'cards'

  relations:
    creator:      {type: HasOne,         schema: 'User'}
    organization: {type: HasOne,         schema: 'Organization'}
    owner:        {type: HasOne,         schema: 'User'}
    participants: {type: HasMany,        schema: 'User'}
    stack:        {type: HasOne,         schema: 'Stack'}
    kind:         {type: HasOne,         schema: 'Kind'}
    goal:         {type: HasOne,         schema: 'Goal'}
    milestone:    {type: HasOne,         schema: 'Milestone'}
    actions:      {type: HasMany,        schema: 'Action'}
    notes:        {type: HasManyForeign, schema: 'Note', index: 'card', order: {field: 'time'}}

module.exports = Card