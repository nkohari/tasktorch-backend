Schema = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

Handoff = Schema.create 'Handoff',

  table: 'handoffs'

  relations:
    card:   {type: HasOne, schema: 'Card'}
    sender: {type: HasOne, schema: 'User'}
    user:   {type: HasOne, schema: 'User'}
    team:   {type: HasOne, scheam: 'Team'}

module.exports = Handoff
