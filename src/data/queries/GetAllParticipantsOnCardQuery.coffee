r     = require 'rethinkdb'
Query = require 'data/framework/queries/Query'
Card  = require 'data/schemas/Card'
User  = require 'data/schemas/User'

class GetAllParticipantsOnCardQuery extends Query

  constructor: (cardId, options) ->
    super(User, options)
    @rql = r.table(User.table).getAll(
      r.args(r.table(Card.table).get(cardId)('participants'))
    )

module.exports = GetAllParticipantsOnCardQuery
