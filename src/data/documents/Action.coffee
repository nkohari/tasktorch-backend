Document     = require 'data/framework/Document'
ActionStatus = require 'data/enums/ActionStatus'

class Action extends Document

  @table   'actions'
  @naming  {singular: 'action', plural: 'actions'}

  @field   'id'
  @field   'version'
  @field   'status', {default: ActionStatus.NotStarted}
  @field   'text'

  @hasOne  'card',   {type: 'Card'}
  @hasOne  'org',    {type: 'Org'}
  @hasOne  'owner',  {type: 'User'}
  @hasMany 'stage',  {type: 'Stage'}

module.exports = Action
