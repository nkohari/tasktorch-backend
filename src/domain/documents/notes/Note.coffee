uuid = require 'common/util/uuid'

class Note

  constructor: (userId, organizationId, cardId) ->
    @id           = uuid()
    @time         = new Date()
    @type         = @constructor.name.replace(/Note$/, '')
    @organization = organizationId
    @card         = cardId
    @user         = userId

module.exports = Note
