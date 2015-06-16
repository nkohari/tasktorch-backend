_ = require 'lodash'

class Config

  constructor: ->
    try
      @env = process.env['NODE_ENV'] ? 'dev'
      tree = require("../../config/#{@env}.config")
      _.extend(this, tree)
    catch err
      throw new Error("Couldn't load configuration for #{@env}: #{err.stack}")

module.exports = Config
