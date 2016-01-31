aws = require 'aws-sdk'

class AWSClientFactory

  constructor: (@config) ->

  createS3Client: ->
    {region, apiVersion} = @config.aws
    new aws.S3 {region, apiVersion, logger: process.stdout}

  createSESClient: ->
    {region, apiVersion} = @config.aws
    new aws.SES {region, apiVersion}

  createSQSClient: ->
    {region, apiVersion} = @config.aws
    new aws.SQS {region, apiVersion}
    
module.exports = AWSClientFactory
