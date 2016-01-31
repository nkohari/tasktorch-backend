GetQuery = require 'data/framework/queries/GetQuery'
File     = require 'data/documents/File'

class GetFileQuery extends GetQuery

  constructor: (id, options) ->
    super(File, id, options)

module.exports = GetFileQuery
