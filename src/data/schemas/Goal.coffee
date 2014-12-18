Schema                   = require 'data/Schema'
{HasOne, HasManyForeign} = require 'data/RelationType'

Goal = Schema.create 'Goal',

  table:    'goals'
  singular: 'goal'
  plural:   'goals'

  relations:
    organization: {type: HasOne, schema: 'Organization'}
    milestones:   {type: HasManyForeign, schema: 'Milestone', index: 'goal'}

module.exports = Goal
