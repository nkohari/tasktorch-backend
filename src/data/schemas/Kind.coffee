Schema = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

Kind = Schema.create 'Kind',

  table: 'kinds'

  relations:
    organization: {type: HasOne, schema: 'Organization'}

module.exports = Kind
