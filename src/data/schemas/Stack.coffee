Schema = require '../framework/Schema'
{HasOne, HasMany} = require '../framework/RelationType'

Stack = Schema.create 'Stack',

  table: 'stacks'

  relations:
    organization: {type: HasOne,  schema: 'Organization'}
    owner:        {type: HasOne,  schema: 'User'}
    team:         {type: HasOne,  schema: 'Team'}
    cards:        {type: HasMany, schema: 'Card'}

module.exports = Stack
