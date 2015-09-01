util     = require 'util'
humanize = require 'humanize'
winston  = require 'winston'

delegate = (name) ->
  (args...) -> @logger[name].apply(@logger, args)

class Log

  constructor: (@app, @config) ->

    transport = new winston.transports.Console
      level: @config.log.level
      timestamp: => "#{@app.name} #{process.pid} - [#{humanize.date('Y-m-d h:i:s')}]"

    @logger = new winston.Logger
      transports: [transport]

  info:  delegate('info')
  debug: delegate('debug')
  error: delegate('error')
  warn:  delegate('warn')

  inspect: (obj, depth, color = true) ->
    @logger.debug util.inspect(obj, false, depth, color)

module.exports = Log
