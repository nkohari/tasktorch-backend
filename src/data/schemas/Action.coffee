Schema = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

Action = Schema.create 'Action',

  table: 'actions'

  relations:
    card:  {type: HasOne, schema: 'Card'}
    owner: {type: HasOne, schema: 'User'}
    stage: {type: HasOne, schema: 'Stage'}

module.exports = Action
