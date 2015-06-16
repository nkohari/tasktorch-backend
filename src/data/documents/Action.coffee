Document     = require 'data/framework/Document'
ActionStatus = require 'data/enums/ActionStatus'

class Action extends Document

  @table   'actions'
  @naming  {singular: 'action', plural: 'actions'}

  @field   'id'
  @field   'version'
  @field   'created'
  @field   'updated'
  @field   'status',    {default: ActionStatus.NotStarted}
  @field   'text',      {default: null}
  @field   'completed', {default: null}

  @hasOne  'card',      {type: 'Card'}
  @hasMany 'checklist', {type: 'Checklist'}
  @hasOne  'org',       {type: 'Org'}
  @hasOne  'stage',     {type: 'Stage'}
  @hasOne  'user',      {type: 'User', default: null}

module.exports = Action
