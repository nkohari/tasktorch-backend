Entity = require '../framework/Entity'
User   = require './User'

class Session extends Entity

  @table 'sessions'

  @field 'isActive', Entity.DataType.BOOLEAN
  
  @hasOne 'user', User

module.exports = Session
