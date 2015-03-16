_               = require 'lodash'
expect          = require('chai').expect
TestHarness     = require 'test/framework/TestHarness'
CommonBehaviors = require 'test/framework/CommonBehaviors'
GetStageHandler = require 'http/handlers/stages/GetStageHandler'

describe 'GetStageHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(GetStageHandler)
      ready()

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', stageid: 'stage-scheme-plan'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'doesnotexist', stageid: 'stage-scheme-plan', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent stage', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', stageid: 'doesnotexist', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a valid stage in an org of which the requester is a member', ->
    it 'returns the stage', (done) ->
      @tester.request {orgid: 'org-paddys', stageid: 'stage-scheme-plan', credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {stage} = res.result
        expect(stage).to.exist()
        expect(stage.id).to.equal('stage-scheme-plan')
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid: 'org-sudz', stageid: 'stage-task-do', credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and stageid', ->
    it 'returns 404 not found', (done) ->
      @tester.request {orgid: 'org-paddys', stageid: 'stage-task-do', credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
