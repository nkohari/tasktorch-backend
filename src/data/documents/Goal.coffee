Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Goal extends Document

  @table  'goals'
  @naming {singular: 'goal', plural: 'goals'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'
  @field  'status',  {default: DocumentStatus.Normal}
  @field  'name'

  @hasOne  'org',   {type: 'Org'}
  @hasMany 'cards', {type: 'Card', default: []}

module.exports = Goal
