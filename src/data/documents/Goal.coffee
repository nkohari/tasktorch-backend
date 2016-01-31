Document   = require 'data/framework/Document'
GoalStatus = require 'data/enums/GoalStatus'

class Goal extends Document

  @table  'goals'
  @naming {singular: 'goal', plural: 'goals'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'
  @field  'status',      {default: GoalStatus.Normal}
  @field  'name'
  @field  'description', {default: null}
  @field  'timeframe',   {default: null}

  @hasOne  'org',   {type: 'Org'}
  @hasMany 'cards', {type: 'Card', default: []}

module.exports = Goal
