expect              = require('chai').expect
TestData            = require 'test/framework/TestData'
TestHarness         = require 'test/framework/TestHarness'
CommonBehaviors     = require 'test/framework/CommonBehaviors'
CreateActionHandler = require 'http/handlers/actions/CreateActionHandler'

describe 'CreateActionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateActionHandler)
      ready()

  reset = (callback) ->
    TestData.reset ['actions', 'cards', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', cardid: 'card-takedbaby'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->
    it 'returns 404 not found', (done) ->
      payload = {stage: 'stage-scheme-plan', text: 'Test'}
      @tester.request {orgid: 'doesnotexist', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent action', ->
    it 'returns 404 not found', (done) ->
      payload = {stage: 'stage-scheme-plan', text: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'doesnotexist', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a stage argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {test: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a non-existent stage argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {stage: 'doesnotexist', text: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a text argument', ->
    it 'returns 400 bad request', (done) ->
      payload = {stage: 'stage-scheme-plan'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null text argument', ->
    it 'creates an action with null text on the specified card', (done) ->
      payload = {stage: 'stage-scheme-plan', text: null}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal('card-takedbaby')
        expect(action.text).to.equal(null)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid text argument', ->
    it 'creates an action with the specified text on the specified card', (done) ->
      payload = {stage: 'stage-scheme-plan', text: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-takedbaby', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal('card-takedbaby')
        expect(action.text).to.equal('Test')
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->
    it 'returns 403 forbidden', (done) ->
      payload = {stage: 'stage-scheme-plan', text: 'Test'}
      @tester.request {orgid: 'org-sudz', cardid: 'card-ringbell', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and cardid', ->
    it 'returns 404 not found', (done) ->
      payload = {stage: 'stage-scheme-plan', text: 'Test'}
      @tester.request {orgid: 'org-paddys', cardid: 'card-ringbell', credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()
        
#---------------------------------------------------------------------------------------------------
