GetQuery = require 'data/framework/queries/GetQuery'
Team     = require 'data/documents/Team'

class GetTeamQuery extends GetQuery

  constructor: (id, options) ->
    super(Team, id, options)

module.exports = GetTeamQuery
