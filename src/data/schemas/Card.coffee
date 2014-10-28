Schema = require '../framework/Schema'
{HasOne, HasMany} = require '../framework/RelationType'

Card = Schema.create 'Card',

  table: 'cards'

  relations:
    creator:      {type: HasOne,  schema: 'User'}
    organization: {type: HasOne,  schema: 'Organization'}
    owner:        {type: HasOne,  schema: 'User'}
    participants: {type: HasMany, schema: 'User'}
    stack:        {type: HasMany, schema: 'Stack'}
    type:         {type: HasOne,  schema: 'Type'}

module.exports = Card
