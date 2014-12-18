Schema   = require 'data/Schema'
{HasOne} = require 'data/RelationType'

Milestone = Schema.create 'Milestone',

  table:    'milestones'
  singular: 'milestone'
  plural:   'milestones'

  relations:
    organization: {type: HasOne, schema: 'Organization'}
    goal:         {type: HasOne, schema: 'Goal'}

module.exports = Milestone
