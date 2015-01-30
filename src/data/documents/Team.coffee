Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Team extends Document

  @table  'teams'
  @naming {singular: 'team', plural: 'teams'}

  @field  'id'
  @field  'version'
  @field  'status',   {default: DocumentStatus.Normal}
  @field  'name'

  @hasOne  'org',     {type: 'Org'}
  @hasMany 'leaders', {type: 'User', default: []}
  @hasMany 'members', {type: 'User', default: []}
  @hasMany 'stacks',  {type: 'Stack', default: []}

module.exports = Team
