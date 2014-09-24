Entity       = require '../framework/Entity'
Organization = require './Organization'
Stack        = require './Stack'
User         = require './User'

class Team extends Entity

  @table 'teams'

  @field 'name', Entity.DataType.STRING
  
  @hasOne 'organization', Organization
  @hasMany 'leaders', User
  @hasMany 'members', User
  @hasMany 'stacks', Stack

module.exports = Team
