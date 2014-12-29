GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Card              = require 'data/schemas/Card'
User              = require 'data/schemas/User'

class GetAllParticipantsOnCardQuery extends GetAllByListQuery

  constructor: (cardId, options) ->
    super(User, Card, cardId, 'participants', options)

module.exports = GetAllParticipantsOnCardQuery
