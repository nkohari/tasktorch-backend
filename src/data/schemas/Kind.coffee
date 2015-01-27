Schema            = require 'data/Schema'
{HasOne, HasMany} = require 'data/RelationType'

Kind = Schema.create 'Kind',

  table:    'kinds'
  singular: 'kind'
  plural:   'kinds'

  relations:
    org:    {type: HasOne,  schema: 'Org'}
    stages: {type: HasMany, schema: 'Stage'}

module.exports = Kind
