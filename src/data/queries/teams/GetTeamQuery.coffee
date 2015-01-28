GetQuery = require 'data/framework/queries/GetQuery'
Team     = require 'data/schemas/Team'

class GetTeamQuery extends GetQuery

  constructor: (id, options) ->
    super(Team, id, options)

module.exports = GetTeamQuery
