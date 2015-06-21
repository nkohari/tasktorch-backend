_                  = require 'lodash'
expect             = require('chai').expect
TestData           = require 'test/framework/TestData'
TestHarness        = require 'test/framework/TestHarness'
CommonBehaviors    = require 'test/framework/CommonBehaviors'
DeleteStackHandler = require 'apps/api/handlers/stacks/DeleteStackHandler'

describe 'DeleteStackHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(DeleteStackHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['stacks'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', stackid: 'stack-charlie-dreams'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    orgid   = 'doesnotexist'
    stackid = 'stack-charlie-dreams'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent stack', ->
    orgid   = 'org-paddys'
    stackid = 'doesnotexist'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-backlog stack', ->
    orgid   = 'org-paddys'
    stackid = 'stack-charlie-inbox'
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, stackid, credentials}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a backlog stack which contains cards', ->
    orgid   = 'org-paddys'
    stackid = 'stack-gruesometwosome-plans'
    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, stackid, credentials}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()
        
#---------------------------------------------------------------------------------------------------

  describe 'when called for an empty backlog stack in an org of which the requester is a member', ->
    orgid   = 'org-paddys'
    stackid = 'stack-charlie-dreams'
    it "sets the stack's status to Deleted", (done) ->
      @tester.request {orgid, stackid, credentials}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {stack} = res.result
        expect(stack).to.exist()
        expect(stack.id).to.equal(stackid)
        expect(stack.status).to.equal('Deleted')
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    orgid   = 'org-sudz'
    stackid = 'stack-sudz-inbox'
    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, stackid, credentials}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and stackid', ->
    orgid   = 'org-paddys'
    stackid = 'stack-sudz-inbox'
    it 'returns 404 not found', (done) ->
      @tester.request {orgid, stackid, credentials}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------
