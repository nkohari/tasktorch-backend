Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class Stack extends Document

  @table   'stacks'
  @naming  {singular: 'stack', plural: 'stacks'}

  @field   'id'
  @field   'version'
  @field   'created'
  @field   'updated'
  @field   'status', {default: DocumentStatus.Normal}
  @field   'name',   {default: null}
  @field   'type'

  @hasOne  'org',    {type: 'Org'}
  @hasOne  'user',   {type: 'User', default: null}
  @hasOne  'team',   {type: 'Team', default: null}
  @hasMany 'cards',  {type: 'Card', default: []}

module.exports = Stack
