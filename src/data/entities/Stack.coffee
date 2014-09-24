Entity       = require '../framework/Entity'
Card         = require './Card'
Organization = require './Organization'
Team         = require './Team'
User         = require './User'

class Stack extends Entity

  @table 'stacks'

  @field 'name', Entity.DataType.STRING
  
  @hasOne 'organization', Organization
  @hasOne 'owner', User
  @hasOne 'team', Team
  @hasMany 'cards', Card

module.exports = Stack
