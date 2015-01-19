_               = require 'lodash'
async           = require 'async'
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

  loadRequestData: (request, steps, callback) ->
    funcs = _.map steps, (func) => func.bind(this, request)
    async.parallel funcs, (err, data) =>
      return callback(err) if err?
      callback null, _.extend.apply(null, data)

  getQueryOptions: (request) ->
    new QueryOptions(request)

  getRequestMetadata: (request) ->
    new RequestMetadata(request)

module.exports = Handler
