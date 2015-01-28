GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Card              = require 'data/schemas/Card'
User              = require 'data/schemas/User'

class GetAllFollowersByCardQuery extends GetAllByListQuery

  constructor: (cardid, options) ->
    super(User, Card, cardid, 'followers', options)

module.exports = GetAllFollowersByCardQuery
