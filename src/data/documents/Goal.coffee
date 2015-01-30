Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Goal extends Document

  @table  'goals'
  @naming {singular: 'goal', plural: 'goals'}

  @field  'id'
  @field  'version'
  @field  'status',  {default: DocumentStatus.Normal}
  @field  'name'
  @field  'deadline'

  @hasOne 'org',     {type: 'Org'}

module.exports = Goal
