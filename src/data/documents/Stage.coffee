Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Stage extends Document

  @table  'stages'
  @naming {singular: 'stage', plural: 'stages'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'  
  @field  'status', {default: DocumentStatus.Normal}
  @field  'name'
  @field  'defaultActions', {default: []}

  @hasOne 'org',    {type: 'Org'}
  @hasOne 'kind',   {type: 'Kind'}

module.exports = Stage
