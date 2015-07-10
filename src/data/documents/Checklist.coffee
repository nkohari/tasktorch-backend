Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Checklist extends Document

  @table  'checklists'
  @naming {singular: 'checklist', plural: 'checklists'}

  @field   'id'
  @field   'version', {default: 0}
  @field   'status',  {default: DocumentStatus.Normal}
  @field   'created'
  @field   'updated'

  @hasOne  'org',     {type: 'Org'}
  @hasOne  'card',    {type: 'Card'}
  @hasOne  'stage',   {type: 'Stage'}
  @hasMany 'actions', {type: 'Action', default: []}

module.exports = Checklist
