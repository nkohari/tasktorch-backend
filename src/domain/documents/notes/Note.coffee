uuid = require 'common/util/uuid'

class Note

  constructor: (userId, orgId, cardId) ->
    @id   = uuid()
    @time = new Date()
    @type = @constructor.name.replace(/Note$/, '')
    @org  = orgId
    @card = cardId
    @user = userId

module.exports = Note
