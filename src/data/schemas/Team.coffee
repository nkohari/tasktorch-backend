Schema = require '../framework/Schema'
{HasOne, HasMany, HasManyForeign} = require '../framework/RelationType'

Team = Schema.create 'Team',

  table: 'teams'

  relations:
    organization: {type: HasOne,         schema: 'Organization'}
    leaders:      {type: HasMany,        schema: 'User'}
    members:      {type: HasMany,        schema: 'User'}
    stacks:       {type: HasManyForeign, schema: 'Stack', index: 'team'}

module.exports = Team
