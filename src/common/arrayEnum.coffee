_ = require 'lodash'

module.exports = arrayEnum = (values) ->
  _.object _.map values, (v) -> [v, v]
