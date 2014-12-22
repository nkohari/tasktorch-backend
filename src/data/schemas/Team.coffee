Schema            = require 'data/Schema'
{HasOne, HasMany} = require 'data/RelationType'

Team = Schema.create 'Team',

  table:    'teams'
  singular: 'team'
  plural:   'teams'

  relations:
    organization: {type: HasOne,  schema: 'Organization'}
    leaders:      {type: HasMany, schema: 'User'}
    members:      {type: HasMany, schema: 'User'}
    stacks:       {type: HasMany, schema: 'Stack'}

module.exports = Team
