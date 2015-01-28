_        = require 'lodash'
async    = require 'async'
Hapi     = require 'hapi'
Boom     = require 'boom'
Response = require './Response'

class Handler

  error: Boom

  @route: (route) ->
    [verb, path] = route.split(/\s+/, 2)
    (@options ?= {}).route = {verb, path}

  @pre: (pre) ->
    (@options ?= {}).pre = pre
    
  @auth: (auth) ->
    @options ?= {}
    (@options.config ?= {}).auth = auth

  handle: (request, reply) ->
    throw new Error("You must implement handle() on #{@constructor.name}")

  response: (content) ->
    new Response(content)

module.exports = Handler
