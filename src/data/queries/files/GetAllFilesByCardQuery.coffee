r                 = require 'rethinkdb'
GetAllByListQuery = require 'data/framework/queries/GetAllByListQuery'
File              = require 'data/documents/File'
Card              = require 'data/documents/Card'

class GetAllFilesByCardQuery extends GetAllByListQuery

  constructor: (cardid, options) ->
    super(File, Card, cardid, 'files', options)

module.exports = GetAllFilesByCardQuery
