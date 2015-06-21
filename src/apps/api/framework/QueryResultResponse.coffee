_     = require 'lodash'
Model = require 'domain/framework/Model'

class QueryResultResponse

  constructor: (result) ->
    
    schema = result.doctype.getSchema()

    if result[schema.getPlural()] isnt undefined
      @[schema.getPlural()] = _.map result[schema.getPlural()], (item) -> Model.create(item)
    else
      name = schema.getSingular()
      if result[name] is null
        @[name] = null
      else
        @[name] = Model.create(result[name])

    unless _.isEmpty(result.related)
      @related = {}
      for kind, hash of result.related
        @related[kind] = _.object _.map hash, (item, id) -> [id, Model.create(item)]

module.exports = QueryResultResponse
