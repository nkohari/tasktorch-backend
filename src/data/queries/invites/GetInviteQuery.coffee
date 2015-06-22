GetQuery = require 'data/framework/queries/GetQuery'
Invite   = require 'data/documents/Invite'

class GetInviteQuery extends GetQuery

  constructor: (id, options) ->
    super(Invite, id, options)

module.exports = GetInviteQuery
