Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Checklist extends Document

  @table  'checklists'
  @naming {singular: 'checklist', plural: 'checklists'}

  @field   'id'
  @field   'version'
  @field   'created'
  @field   'updated'
  @field   'status',  {default: DocumentStatus.Normal}

  @hasOne  'org',     {type: 'Org'}
  @hasOne  'card',    {type: 'Card'}
  @hasOne  'stage',   {type: 'Stage'}
  @hasMany 'actions', {type: 'Action', default: []}

module.exports = Checklist
