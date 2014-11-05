Schema = require '../framework/Schema'
{HasOne, HasManyForeign} = require '../framework/RelationType'

Stack = Schema.create 'Stack',

  table: 'stacks'

  relations:
    organization: {type: HasOne, schema: 'Organization'}
    owner:        {type: HasOne, schema: 'User'}
    team:         {type: HasOne, schema: 'Team'}
    cards:        {type: HasManyForeign, schema: 'Card', index: 'stack'}

module.exports = Stack
