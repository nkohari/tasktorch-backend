Schema = require '../framework/Schema'
{HasOne, HasManyForeign} = require '../framework/RelationType'

Kind = Schema.create 'Kind',

  table: 'kinds'

  relations:
    organization: {type: HasOne,         schema: 'Organization'}
    stages:       {type: HasManyForeign, schema: 'Kind', index: 'kind'}

module.exports = Kind
