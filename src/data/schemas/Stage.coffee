Schema   = require 'data/Schema'
{HasOne} = require 'data/RelationType'

Stage = Schema.create 'Stage',

  table:    'stages'
  singular: 'stage'
  plural:   'stages'

  relations:
    kind: {type: HasOne, schema: 'Kind'}

module.exports = Stage
