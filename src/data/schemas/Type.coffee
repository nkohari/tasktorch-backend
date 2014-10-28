Schema = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

# TODO: Rename to something that isn't dumb
Type = Schema.create 'Type',

  table: 'types'

  relations:
    organization: {type: HasOne, schema: 'Organization'}

module.exports = Type
