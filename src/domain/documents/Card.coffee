uuid       = require 'common/util/uuid'
CardStatus = 'domain/enums/CardStatus'

class Card

  constructor: (data) ->
    @id        = data.id        ? uuid()
    @status    = data.status    ? CardStatus.Normal
    @org       = data.org
    @creator   = data.creator
    @owner     = data.owner     ? null
    @kind      = data.kind
    @stack     = data.stack
    @followers = data.followers ? []
    @moves     = data.moves     ? []
    @actions   = data.actions

module.exports = Card
