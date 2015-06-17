GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
Card              = require 'data/documents/Card'
User              = require 'data/documents/User'

class GetAllFollowersByCardQuery extends GetAllByListQuery

  constructor: (cardid, options) ->
    super(User, Card, cardid, 'followers', options)

module.exports = GetAllFollowersByCardQuery
