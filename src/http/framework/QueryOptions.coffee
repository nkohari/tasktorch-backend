class QueryOptions

  constructor: (request) ->
    @pluck  = request.query.fields?.split(',')
    @expand = request.query.expand?.split(',')

module.exports = QueryOptions
