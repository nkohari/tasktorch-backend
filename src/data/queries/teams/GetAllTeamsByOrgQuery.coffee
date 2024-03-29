r                  = require 'rethinkdb'
Team               = require 'data/documents/Team'
GetAllByIndexQuery = require 'data/framework/queries/GetAllByIndexQuery'

class GetAllTeamsByOrgQuery extends GetAllByIndexQuery

  constructor: (orgid, options) ->
    super(Team, {org: orgid}, options)

module.exports = GetAllTeamsByOrgQuery
