_                   = require 'lodash'
async               = require 'async'
Hapi                = require 'hapi'
Joi                 = require 'joi'
Boom                = require 'boom'
Document            = require 'data/framework/Document'
QueryResult         = require 'data/framework/QueryResult'
DocumentResponse    = require './DocumentResponse'
QueryResultResponse = require './QueryResultResponse'

class Handler

  @mustBe: Joi
  error:   Boom

  @route: (route) ->
    [verb, path] = route.split(/\s+/, 2)
    (@options ?= {}).route = {verb, path}

  @before: (preconditions) ->
    (@options ?= {}).preconditions = preconditions

  @config: (config = {}) ->
    @options ?= {}
    @options.config = _.extend {}, @options.config, config
    
  @auth: (auth) ->
    @options ?= {}
    (@options.config ?= {}).auth = auth

  @ensure: (spec) ->
    @options ?= {}
    (@options.config ?= {}).validate = spec

  handle: (request, reply) ->
    throw new Error("You must implement handle() on #{@constructor.name}")

  response: (content) ->
    if content instanceof Document
      return new DocumentResponse(content)
    else if content instanceof QueryResult
      return new QueryResultResponse(content)
    else
      throw new Error("Don't know how to create a response for content of type #{content.constructor.name}")

module.exports = Handler
