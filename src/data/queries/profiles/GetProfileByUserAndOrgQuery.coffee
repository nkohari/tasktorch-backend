GetByIndexQuery = require 'data/framework/queries/GetByIndexQuery'
Profile         = require 'data/documents/Profile'

class GetProfileByUserAndOrgQuery extends GetByIndexQuery

  constructor: (userid, orgid, options) ->
    super(Profile, {'user-org': [userid, orgid]}, options)

module.exports = GetProfileByUserAndOrgQuery
