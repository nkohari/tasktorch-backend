_ = require 'lodash'

class Property

  constructor: (@parent, @name, config = {}) ->
    @default = config.default

  getDefault: ->
    if _.isFunction(@default) then @default() else @default

module.exports = Property
