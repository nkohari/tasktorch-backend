_         = require 'lodash'
path      = require 'path'
loadFiles = require 'common/util/loadFiles'

CLASSES = undefined
getClassHash = ->
  unless CLASSES?
    files   = loadFiles('models', __dirname)
    CLASSES = _.indexBy files, (t) -> t.name.replace(/Model$/, '')
  return CLASSES

class Model

  @create: (document) ->
    schema = document.getSchema()
    klass  = getClassHash()[schema.name]
    throw new Error("Cannot create model for document with type #{schema.name}") unless klass?
    return new klass(document)

  constructor: (document) ->
    @id      = document.id
    @version = document.version

module.exports = Model
