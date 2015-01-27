Schema    = require 'data/Schema'
{HasMany} = require 'data/RelationType'

Org = Schema.create 'Org',

  table:    'orgs'
  singular: 'org'
  plural:   'orgs'

  relations:
    teams:   {type: HasMany, schema: 'Team'}
    leaders: {type: HasMany, schema: 'User'}
    members: {type: HasMany, schema: 'User'}

module.exports = Org
