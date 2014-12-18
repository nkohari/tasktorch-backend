_         = require 'lodash'
path      = require 'path'
loadFiles = require 'common/util/loadFiles'
Model     = require 'domain/Model'

CLASSES = undefined
getClassHash = ->
  unless CLASSES?
    files   = loadFiles('messages', __dirname)
    CLASSES = _.indexBy files, (t) -> t.name.replace(/Message$/, '')
  return CLASSES

class Message

  @create: (activity, document) ->
    schema = document.getSchema()
    klass  = getClassHash()[schema.name]
    throw new Error("Cannot create message for document with schema #{schema.name}") unless klass?
    return new klass(activity, document)

  constructor: (@activity, document) ->
    @type     = document.getSchema().name
    @document = Model.create(document)

module.exports = Message
