_ = require 'lodash'

class Email

  constructor: (msg) ->
    @type    = msg.type
    @to      = _.flatten [msg.to]
    @cc      = _.flatten [msg.cc] if msg.cc?
    @bcc     = _.flatten [msg.bcc] if msg.bcc?
    @from    = msg.from
    @replyTo = _.flatten [msg.replyTo] if msg.replyTo?
    @subject = msg.subject
    @params  = msg.params ? {}

module.exports = Email
