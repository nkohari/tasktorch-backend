GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'
Checklist          = require 'data/documents/Checklist'

class GetAllChecklistsByCardQuery extends GetAllByIndexQuery

  constructor: (cardid, options) ->
    super(Checklist, {card: cardid}, options)

module.exports = GetAllChecklistsByCardQuery
