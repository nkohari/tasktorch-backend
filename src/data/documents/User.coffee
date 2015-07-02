Document       = require 'data/framework/Document'
DocumentStatus = require 'data/enums/DocumentStatus'
UserLevel      = require 'data/enums/UserLevel'

class User extends Document

  @table  'users'
  @naming {singular: 'user', plural: 'users'}

  @field  'id'
  @field  'version'
  @field  'created'
  @field  'updated'  
  @field  'status',  {default: DocumentStatus.Normal}
  @field  'username'
  @field  'password'
  @field  'name'
  @field  'email'
  @field  'level',   {default: UserLevel.Normal}

module.exports = User
