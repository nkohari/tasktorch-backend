expect                  = require('chai').expect
TestHarness             = require 'test/framework/TestHarness'
ChangeActionTextHandler = require 'apps/api/handlers/actions/ChangeActionTextHandler'

describe 'actions:ChangeActionTextHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(ChangeActionTextHandler, 'user-charlie')
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
      payload = {text: 'Test'}
      @tester.request {orgid: 'doesnotexist', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->
    it 'returns 404 not found', (done) ->
      payload = {text: 'Test'}
      @tester.request {orgid: 'org-paddys', actionid: 'doesnotexist', payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a text argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null text argument', ->
    it 'changes the text to null', (done) ->
      payload = {text: null}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        expect(action.id).to.equal('action-takedbaby')
        expect(action.text).to.equal(null)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid text argument', ->
    it 'changes the text to the specified text', (done) ->
      payload = {text: 'Test'}
      @tester.request {orgid: 'org-paddys', actionid: 'action-takedbaby', payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        expect(action.id).to.equal('action-takedbaby')
        expect(action.text).to.equal('Test')
        done()

#---------------------------------------------------------------------------------------------------
