Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Note extends Document

  @table  'notes'
  @naming {singular: 'note', plural: 'notes'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'
  @field  'status', {default: DocumentStatus.Normal}
  @field  'type'
  @field  'content'

  @hasOne 'org',    {type: 'Org'}
  @hasOne 'card',   {type: 'Card'}
  @hasOne 'user',   {type: 'User'}

module.exports = Note
