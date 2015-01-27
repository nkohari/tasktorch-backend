Schema = require 'data/Schema'
{HasOne, HasMany, HasManyForeign} = require 'data/RelationType'

Team = Schema.create 'Team',

  table:    'teams'
  singular: 'team'
  plural:   'teams'

  relations:
    org:     {type: HasOne,         schema: 'Org'}
    leaders: {type: HasMany,        schema: 'User'}
    members: {type: HasMany,        schema: 'User'}
    stacks:  {type: HasManyForeign, schema: 'Stack', index: 'team'}

module.exports = Team
