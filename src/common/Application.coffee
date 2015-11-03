EventEmitter = require('events').EventEmitter
Forge        = require 'forge-di'

class Application extends EventEmitter

  constructor: (environment) ->
    @forge = new Forge()
    console.log("→ Starting #{@constructor.name} in #{environment.constructor.name}...")
    environment.setup(this, @forge)
    @log = @forge.get('log')
    process.title = "torch: #{@name}"
    @setupEvents()
    console.log("→ Ready.")

  setupEvents: ->
    process.on 'SIGINT', =>
      @log.info "Caught SIGINT, stopping #{@name} application"
      @stop()
    process.on 'SIGTERM', =>
      @log.info "Caught SIGTERM, stopping #{@name} application"
      @stop()
    process.stdin.on 'close', =>
      @log.info "STDIN stream closed, stopping #{@name} application"
      @stop(1)

  start: ->
    @log.info "Started #{@name} application"
    @emit('start')

  stop: (exitCode = 0) ->
    @emit('stop')
    @log.info "Stopped #{@name} application"
    process.exit(exitCode)

module.exports = Application
