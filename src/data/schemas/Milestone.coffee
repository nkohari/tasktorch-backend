Schema   = require 'data/Schema'
{HasOne} = require 'data/RelationType'

Milestone = Schema.create 'Milestone',

  table:    'milestones'
  singular: 'milestone'
  plural:   'milestones'

  relations:
    org:  {type: HasOne, schema: 'Org'}
    goal: {type: HasOne, schema: 'Goal'}

module.exports = Milestone
