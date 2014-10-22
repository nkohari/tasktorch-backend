Entity = require '../framework/Entity'
Events = require '../events'

class Card extends Entity

  @table 'cards'

  @field   'title',        Entity.DataType.STRING
  @field   'body',         Entity.DataType.STRING
  @hasOne  'organization', 'Organization'
  @hasOne  'type',         'Type'
  @hasOne  'creator',      'User'
  @hasOne  'owner',        'User'
  @hasMany 'participants', 'User'

  setBody: (user, value) ->
    previous = @body
    @body = value
    @announce new Events.CardBodyChangedEvent(user.id, @organization.id, this, previous, value)

  setTitle: (user, value) ->
    previous = @title
    @title = value
    @announce new Events.CardTitleChangedEvent(user.id, @organization.id, this, previous, value)

module.exports = Card
