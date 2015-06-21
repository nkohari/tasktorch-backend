class QueryOptions

  constructor: (request) ->
    @pluck        = request.query.fields?.split(',')
    @expand       = request.query.expand?.split(',')
    @allowDeleted = !!request.query.allowDeleted

module.exports = QueryOptions
