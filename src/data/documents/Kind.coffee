Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Kind extends Document

  @table   'kinds'
  @naming  {singular: 'kind', plural: 'kinds'}

  @field   'id'
  @field   'version'
  @field   'status', {default: DocumentStatus.Normal}
  @field   'name'
  @field   'color'

  @hasOne  'org',    {type: 'Org'}
  @hasMany 'stages', {type: 'Stage'}

module.exports = Kind