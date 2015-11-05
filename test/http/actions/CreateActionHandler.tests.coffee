expect              = require('chai').expect
TestHarness         = require 'test/framework/TestHarness'
CreateActionHandler = require 'apps/api/handlers/actions/CreateActionHandler'

describe 'actions:CreateActionHandler', ->

#---------------------------------------------------------------------------------------------------

  before (ready) ->
    TestHarness.start (err) =>
      return ready(err) if err?
      @tester = TestHarness.createTester(CreateActionHandler, 'user-charlie')
      ready()

  afterEach (done) ->
    TestHarness.reset ['actions', 'checklists', 'notes'], done

#---------------------------------------------------------------------------------------------------

  describe 'when called without credentials', ->

    orgid       = 'org-paddys'
    checklistid = 'checklist-takedbaby-plan'

    it 'returns 401 unauthorized', (done) ->
      @tester.request {orgid, checklistid, credentials: false}, (res) ->
        expect(res.statusCode).to.equal(401)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent org', ->

    orgid       = 'doesnotexist'
    checklistid = 'checklist-takedbaby-plan'
    payload     = {text: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, checklistid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for a non-existent checklist', ->

    orgid       = 'org-paddys'
    checklistid = 'doesnotexist'
    payload     = {text: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, checklistid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called without a text argument', ->

    orgid       = 'org-paddys'
    checklistid = 'checklist-takedbaby-plan'
    payload     = {}

    it 'returns 400 bad request', (done) ->
      @tester.request {orgid, checklistid, payload}, (res) =>
        expect(res.statusCode).to.equal(400)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a null text argument', ->

    orgid       = 'org-paddys'
    cardid      = 'card-takedbaby'
    checklistid = 'checklist-takedbaby-plan'
    stageid     = 'stage-scheme-plan'
    payload     = {text: null}

    it 'creates an action with null text in the specified checklist of the specified card', (done) ->
      @tester.request {orgid, checklistid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        expect(action.text).to.equal(null)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a valid text argument', ->
    
    orgid       = 'org-paddys'
    cardid      = 'card-takedbaby'
    checklistid = 'checklist-takedbaby-plan'
    stageid     = 'stage-scheme-plan'
    payload     = {text: new Date().valueOf().toString()}

    it 'creates an action with the specified text in the specified checklist of the specified card', (done) ->
      @tester.request {orgid, checklistid, payload}, (res) =>
        expect(res.statusCode).to.equal(200)
        expect(res.result).to.exist
        {action} = res.result
        expect(action.card).to.equal(cardid)
        expect(action.checklist).to.equal(checklistid)
        expect(action.stage).to.equal(stageid)
        expect(action.text).to.equal(payload.text)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called for an org of which the requester is not a member', ->

    orgid       = 'org-sudz'
    checklistid = 'checklist-ringbell-do'
    payload     = {text: 'Test'}

    it 'returns 403 forbidden', (done) ->
      @tester.request {orgid, checklistid, payload}, (res) =>
        expect(res.statusCode).to.equal(403)
        done()

#---------------------------------------------------------------------------------------------------

  describe 'when called with a mismatched orgid and checklistid', ->

    orgid       = 'org-paddys'
    checklistid = 'checklist-ringbell-do'
    payload     = {text: 'Test'}

    it 'returns 404 not found', (done) ->
      @tester.request {orgid, checklistid, payload}, (res) =>
        expect(res.statusCode).to.equal(404)
        done()
        
#---------------------------------------------------------------------------------------------------
