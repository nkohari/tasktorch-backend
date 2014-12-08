_     = require 'lodash'
Model = require './Model'

class Response

  constructor: (result) ->

    schema = result.schema
    if result[schema.plural] isnt undefined
      @[schema.plural] = _.map result[schema.plural], (item) -> Model.create(item)
    else
      if result[schema.singular] is null
        @[schema.singular] = null
      else
        @[schema.singular] = Model.create(result[schema.singular])

    unless _.isEmpty(result.related)
      @related = {}
      for kind, hash of result.related
        @related[kind] = _.object _.map hash, (item, id) -> [id, Model.create(item)]

module.exports = Response
