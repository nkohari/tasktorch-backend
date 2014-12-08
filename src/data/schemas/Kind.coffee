Schema = require '../framework/Schema'
{HasOne, HasMany} = require '../framework/RelationType'

Kind = Schema.create 'Kind',

  table:    'kinds'
  singular: 'kind'
  plural:   'kinds'

  relations:
    organization: {type: HasOne,  schema: 'Organization'}
    stages:       {type: HasMany, schema: 'Stage'}

module.exports = Kind
