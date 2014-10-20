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

  setBody: (value) ->
    previous = @body
    @body = value
    @announce new Events.CardBodyEditedEvent(this, previous, value)

  setTitle: (value) ->
    previous = @title
    @title = value
    @announce new Events.CardTitleEditedEvent(this, previous, value)

module.exports = Card
