Schema = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

Stage = Schema.create 'Stage',

  table: 'stages'

  relations:
    kind: {type: HasOne, schema: 'Kind'}

module.exports = Stage
