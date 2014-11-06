Schema = require '../framework/Schema'
{HasOne} = require '../framework/RelationType'

Milestone = Schema.create 'Milestone',

  table: 'milestones'

  relations:
    organization: {type: HasOne, schema: 'Organization'}
    goal:         {type: HasOne, schema: 'Goal'}

module.exports = Milestone
