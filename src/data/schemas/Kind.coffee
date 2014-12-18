Schema            = require 'data/Schema'
{HasOne, HasMany} = require 'data/RelationType'

Kind = Schema.create 'Kind',

  table:    'kinds'
  singular: 'kind'
  plural:   'kinds'

  relations:
    organization: {type: HasOne,  schema: 'Organization'}
    stages:       {type: HasMany, schema: 'Stage'}

module.exports = Kind
