Schema = require '../framework/Schema'
{HasMany} = require '../framework/RelationType'

Organization = Schema.create 'Organization',

  table:    'organizations'
  singular: 'organization'
  plural:   'organizations'

  relations:
    teams:   {type: HasMany, schema: 'Team'}
    leaders: {type: HasMany, schema: 'User'}
    members: {type: HasMany, schema: 'User'}

module.exports = Organization
