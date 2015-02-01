Model = require 'domain/framework/Model'

class Message

  constructor: (@activity, document) ->
    @type     = document.getSchema().name
    @document = Model.create(document)

module.exports = Message
