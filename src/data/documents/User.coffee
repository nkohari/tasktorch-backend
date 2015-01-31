Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'

class User extends Document

  @table  'users'
  @naming {singular: 'user', plural: 'users'}

  @field  'id'
  @field  'version'
  @field  'status',  {default: DocumentStatus.Normal}
  @field  'username'
  @field  'password'
  @field  'name'
  @field  'emails'

module.exports = User