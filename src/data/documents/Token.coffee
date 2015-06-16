_              = require 'lodash'
Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Token extends Document

  @table  'tokens'
  @naming {singular: 'token', plural: 'tokens'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'
  @field  'status',  {default: DocumentStatus.Normal}
  @field  'comment', {default: null}

  @hasOne 'creator', {type: 'User'}
  @hasOne 'org',     {type: 'Org', default: null}

module.exports = Token
