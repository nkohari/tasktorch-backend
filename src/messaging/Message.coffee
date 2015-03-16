Model = require 'domain/framework/Model'

class Message

  constructor: (@activity, document, previous = undefined) ->
    @type     = document.getSchema().name
    @document = Model.create(document)
    @previous = Model.create(previous) if previous?

module.exports = Message
