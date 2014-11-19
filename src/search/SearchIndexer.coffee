_ = require 'lodash'

class SearchIndexer

  constructor: (@forge, @config, @log, @searchEngine) ->
    factories = @forge.getAll('searchModelFactory')
    @factories = _.indexBy factories, (f) -> f.constructor.handles

  handle: (event, callback) ->
    factory = @factories[event.document.type]
    return callback() unless factory?
    factory.create event.document.id, (err, model) =>
      return callback(err) if err?
      return callback() unless model?
      @searchEngine.index {
        index: @config.elasticsearch.index
        type:  model.constructor.type
        id:    event.document.id
        body:  model
      }, (err, response) =>
        return callback(err) if err?
        @log.debug(response)
        callback()

module.exports = SearchIndexer
