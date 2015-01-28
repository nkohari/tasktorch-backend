uuid = require 'common/util/uuid'

class Note

  constructor: (userid, orgid, cardid) ->
    @id   = uuid()
    @time = new Date()
    @type = @constructor.name.replace(/Note$/, '')
    @org  = orgid
    @card = cardid
    @user = userid

module.exports = Note
