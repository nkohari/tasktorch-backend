r               = require 'rethinkdb'
Card            = require 'data/documents/Card'
UpdateStatement = require 'data/statements/UpdateStatement'

class AddFollowerToCardStatement extends UpdateStatement

  constructor: (cardid, userid) ->
    patch = {followers: r.row('followers').setInsert(userid)}
    super(Card, cardid, patch)

module.exports = AddFollowerToCardStatement
