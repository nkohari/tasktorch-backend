GetByIndexQuery = require 'data/framework/queries/GetByIndexQuery'
Org             = require 'data/documents/Org'

class GetOrgByAccountIdQuery extends GetByIndexQuery

  constructor: (accountId, options) ->
    super(Org, {account: accountId}, options)

module.exports = GetOrgByAccountIdQuery
