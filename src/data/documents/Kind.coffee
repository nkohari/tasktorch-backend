_              = require 'lodash'
Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Kind extends Document

  @table   'kinds'
  @naming  {singular: 'kind', plural: 'kinds'}

  @field   'id'
  @field   'version'
  @field   'status',         {default: DocumentStatus.Normal}
  @field   'name'
  @field   'description',    {default: ''}
  @field   'color'
  @field   'nextNumber',     {default: 0}

  @hasOne  'org',            {type: 'Org'}
  @hasMany 'stages',         {type: 'Stage'}

  hasStage: (stageid) ->
    _.contains(@stages, stageid)

module.exports = Kind
