r               = require 'rethinkdb'
Card            = require 'data/documents/Card'
UpdateStatement = require 'data/statements/UpdateStatement'

class RemoveFollowerFromCardStatement extends UpdateStatement

  constructor: (cardid, userid) ->
    patch = {followers: r.row('followers').setDifference([userid])}
    super(Card, cardid, patch)

module.exports = RemoveFollowerFromCardStatement
