GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Card              = require 'data/schemas/Card'
User              = require 'data/schemas/User'

class GetAllFollowersByCardQuery extends GetAllByListQuery

  constructor: (cardId, options) ->
    super(User, Card, cardId, 'followers', options)

module.exports = GetAllFollowersByCardQuery
