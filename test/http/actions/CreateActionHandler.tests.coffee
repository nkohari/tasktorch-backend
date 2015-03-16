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
    TestData.reset ['actions', 'checklists', 'notes'], callback

  credentials =
    user: {id: 'user-charlie'}

#---------------------------------------------------------------------------------------------------

  CommonBehaviors.requiresAuthentication {orgid: 'org-paddys', checklistid: 'checklist-takedbaby-do'}

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    checklistid = 'checklist-takedbaby-plan'
    orgid       = 'doesnotexist'

    it 'returns 404 not found', (done) ->
      payload = {text: 'Test'}
      @tester.request {orgid, checklistid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent checklist', ->

    checklistid = 'doesnotexist'
    orgid       = 'org-paddys'

    it 'returns 404 not found', (done) ->
      payload = {text: 'Test'}
      @tester.request {orgid, checklistid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a text argument', ->

    checklistid = 'checklist-takedbaby-plan'
    orgid       = 'org-paddys'

    it 'returns 400 bad request', (done) ->
      payload = {}
      @tester.request {orgid, checklistid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null text argument', ->

    cardid      = 'card-takedbaby'
    checklistid = 'checklist-takedbaby-plan'
    orgid       = 'org-paddys'
    stageid     = 'stage-scheme-plan'

    it 'creates an action with null text in the specified checklist of the specified card', (done) ->
      payload = {text: null}
      @tester.request {orgid, checklistid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        expect(action.text).to.equal(null)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid text argument', ->

    cardid      = 'card-takedbaby'
    checklistid = 'checklist-takedbaby-plan'
    orgid       = 'org-paddys'
    stageid     = 'stage-scheme-plan'

    it 'creates an action with the specified text in the specified checklist of the specified card', (done) ->
      payload = {text: new Date().valueOf().toString()}
      @tester.request {orgid, checklistid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist()
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        expect(action.text).to.equal(payload.text)
        reset(done)

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    checklistid = 'checklist-ringbell-do'
    orgid       = 'org-sudz'

    it 'returns 403 forbidden', (done) ->
      payload = {text: 'Test'}
      @tester.request {orgid, checklistid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and checklistid', ->

    checklistid = 'checklist-ringbell-do'
    orgid       = 'org-paddys'

    it 'returns 404 not found', (done) ->
      payload = {text: 'Test'}
      @tester.request {orgid, checklistid, credentials, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()
        
#---------------------------------------------------------------------------------------------------
