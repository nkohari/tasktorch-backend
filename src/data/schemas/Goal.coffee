Schema                   = require 'data/Schema'
{HasOne, HasManyForeign} = require 'data/RelationType'

Goal = Schema.create 'Goal',

  table:    'goals'
  singular: 'goal'
  plural:   'goals'

  relations:
    org:        {type: HasOne, schema: 'Org'}
    milestones: {type: HasManyForeign, schema: 'Milestone', index: 'goal'}

module.exports = Goal
