Document     = require 'data/framework/Document'
ActionStatus = require 'data/enums/ActionStatus'

class Action extends Document

  @table   'actions'
  @naming  {singular: 'action', plural: 'actions'}

  @field   'id'
  @field   'version'
  @field   'status', {default: ActionStatus.NotStarted}
  @field   'text',   {default: null}

  @hasOne  'card',   {type: 'Card'}
  @hasOne  'org',    {type: 'Org'}
  @hasOne  'user',   {type: 'User', default: null}
  @hasMany 'stage',  {type: 'Stage'}

module.exports = Action
