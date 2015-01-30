_ = require 'lodash'

class Property

  constructor: (@parent, @name, config = {}) ->
    if _.isFunction(config.default)
      @default = config.default.apply(this)
    else
      @default = config.default

module.exports = Property
