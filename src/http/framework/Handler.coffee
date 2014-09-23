Hapi = require 'hapi'

class Handler

  @table: (name) ->
    (@schema ?= {}).table = name

  @route: (route) ->
    [verb, path] = route.split(/\s+/, 2)
    (@options ?= {}).route = {verb, path}

  @demand: (demand) ->
    (@options ?= {}).demand = demand
    
  @auth: (auth) ->
    @options ?= {}
    (@options.config ?= {}).auth = auth

  constructor: (@log) ->

  error: (err) ->
    @log.debug(err)
    Hapi.error.internal('Something bad happened', err)

  notFound: ->
    Hapi.error.notFound()

  unauthorized: ->
    Hapi.error.unauthorized()

module.exports = Handler
