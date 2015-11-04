expect                    = require('chai').expect
TestData                  = require 'test/framework/TestData'
TestHarness               = require 'test/framework/TestHarness'
CommonBehaviors           = require 'test/framework/CommonBehaviors'
ChangeActionStatusHandler = require 'apps/api/handlers/actions/ChangeActionStatusHandler'

describe 'actions:ChangeActionStatusHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeActionStatusHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['actions', 'notes'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->
    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      payload = {status: 'InProgress'}
      @tester.request {orgid: 'doesnotexist', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->
    it 'returns 404 not found', (done) ->
      payload = {status: 'InProgress'}
      @tester.request {orgid: 'org-paddys', actionid: 'doesnotexist', payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a status argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with an invalid status argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {status: 'doesnotexist'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid status argument', ->
    it 'changes the status to the specified status', (done) ->
      payload = {status: 'InProgress'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.id).to.equal('action-takedbaby')
        expect(action.status).to.equal('InProgress')
        done()

#---------------------------------------------------------------------------------------------------
