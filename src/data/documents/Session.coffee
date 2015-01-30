Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Session extends Document

  @table  'sessions'
  @naming {singular: 'session', plural: 'sessions'}

  @field  'id'
  @field  'version'
  @field  'status', {default: DocumentStatus.Normal}
  @field  'name'
  @field  'isActive' # TODO: Move to status

  @hasOne 'user',   {type: 'User'}

module.exports = Session
