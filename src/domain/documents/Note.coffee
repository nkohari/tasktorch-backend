uuid = require 'common/util/uuid'

class Note

  constructor: (user, card) ->
    @id           = uuid()
    @time         = new Date()
    @type         = @constructor.name.replace(/Note$/, '')
    @organization = card.organization
    @card         = card.id
    @user         = user.id

module.exports = Note
