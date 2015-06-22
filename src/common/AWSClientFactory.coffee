aws = require 'aws-sdk'

class AWSClientFactory

  constructor: (@config) ->

  createSESClient: ->
    {region, apiVersion} = @config.aws
    new aws.SES {region, apiVersion}

  createSQSClient: ->
    {region, apiVersion} = @config.aws
    new aws.SQS {region, apiVersion}
    
module.exports = AWSClientFactory
