Hapi            = require 'hapi'
QueryOptions    = require './QueryOptions'
RequestMetadata = require './RequestMetadata'

class Handler

  error: Hapi.error

  @route: (route) ->
    [verb, path] = route.split(/\s+/, 2)
    (@options ?= {}).route = {verb, path}

  @demand: (demand) ->
    (@options ?= {}).demand = demand
    
  @auth: (auth) ->
    @options ?= {}
    (@options.config ?= {}).auth = auth

  handle: (request, reply) ->
    throw new Error("You must implement handle() on #{@constructor.name}")

  getQueryOptions: (request) ->
    new QueryOptions(request)

  getRequestMetadata: (request) ->
    new RequestMetadata(request)

module.exports = Handler
