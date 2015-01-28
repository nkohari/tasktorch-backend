qs       = require 'querystring'
template = require 'url-template'

class HandlerTester

  constructor: (@server, @handler) ->
    {route} = @handler.options
    @verb = route.verb
    @template = template.parse(route.path)

  request: (args...) ->

    if args.length == 1
      options  = {}
      callback = args[0]
    else
      [options, callback] = args

    url = @template.expand(options)
    url += '?' + qs.stringify(options.query) if options.query?

    @server.inject {
      method:      @verb
      url:         url
      headers:     options.headers                 if options.headers?
      credentials: options.credentials             if options.credentials?
      payload:     JSON.stringify(options.payload) if options.payload?
    }, (res) =>
      res.body = JSON.parse(res.payload) if res.payload?.length > 0
      callback(res)

module.exports = HandlerTester
