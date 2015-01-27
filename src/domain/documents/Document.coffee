uuid           = require 'common/util/uuid'
DocumentStatus = require 'data/DocumentStatus'

class Document

  constructor: (data) ->
    @id      = data.id      ? uuid()
    @version = data.version ? 0
    @status  = data.status  ? DocumentStatus.Normal

module.exports = Document
