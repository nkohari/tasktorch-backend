Entity       = require '../framework/Entity'
Organization = require './Organization'
User         = require './User'

class Card extends Entity

  @table 'cards'

  @field 'id', Entity.DataType.STRING
  @field 'title', Entity.DataType.STRING
  
  @hasOne 'organization', Organization
  @hasOne 'creator', User
  @hasOne 'owner', User
  @hasMany 'participants', User

module.exports = Card
