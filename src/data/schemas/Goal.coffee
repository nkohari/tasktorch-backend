Schema = require '../framework/Schema'
{HasOne, HasManyForeign} = require '../framework/RelationType'

Goal = Schema.create 'Goal',

  table: 'goals'

  relations:
    organization: {type: HasOne, schema: 'Organization'}
    milestones:   {type: HasManyForeign, schema: 'Milestone', index: 'goal'}

module.exports = Goal
