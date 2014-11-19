elasticsearch = require 'elasticsearch'

class SearchEngine

  constructor: (@config) ->
    @client = new elasticsearch.Client {
      hosts: @config.elasticsearch.hosts
    }

  index: (params, callback) ->
    @client.index(params, callback)

module.exports = SearchEngine
